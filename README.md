# Predictive DocV iOS SDK v5

Learn how to quickly integrate with the Predictive Document Verification (DocV) iOS SDK v5 using RiskOS™.

>Note: This guide describes the RiskOS integration. If you are an existing ID+ customer, see [Existing ID+ customers](#existing-id-customers).

## Table of Contents

- [Getting started](#getting-started)
- [Step 1: Generate a transaction token](#step-1-generate-a-transaction-token-and-configure-the-capture-app)
  - [Call the Evaluation endpoint](#call-the-evaluation-endpoint)
- [Step 2: Add the DocV iOS SDK](#step-2-add-the-docv-ios-sdk)
  - [CocoaPods](#cocoapods-deprecated-in-nov-2026)
  - [Swift Package Manager](#swift-package-manager)
  - [Camera permissions](#camera-permissions)
  - [Import SocureDocV](#import-socuredocv)
  - [Initialize and launch the SDK](#initialize-and-launch-the-sdk)
  - [Handle the response](#handle-the-response)
- [Step 3: Receive the verification results](#step-3-receive-the-verification-results)
- [Existing ID+ customers](#existing-id-customers)
- [External dependencies](#external-dependencies)
- [Run locally](#run-locally)
- [Run tests](#run-tests)

## Getting started

Before you begin, ensure you have the following: 

- Configure a DocV workflow and decision logic in [RiskOS DocV setup](https://help.socure.com/riskos/docs/docv-riskos-setup). The Evaluation endpoint cannot return a transaction token until DocV is set up in your workflow.
- Get a valid API key from the [Developer Workbench > API Keys](https://riskos.socure.com/developers/api-keys) page in RiskOS to authenticate API requests.
- Get a valid SDK key from the [Developer Workbench > SDK Keys](https://help.socure.com/riskos/docs/integration-guide-authentication) page in RiskOS to initialize and authenticate the DocV iOS SDK.
- (Optional) Add your IP address to the [allowlist](https://help.socure.com/riskos/docs/ip-filtering) in RiskOS.

### iOS SDK integration notes

Check that your development environment meets the following requirements:
  - Xcode version 16.1+
  - Support for iOS 15 and later

#### iOS Device SDK and DocV SDK compatibility

When integrating the **DocV SDK** on iOS, you do not need to include both the **Device SDK** and the **DocV SDK**. The DocV SDK already includes the full functionality of the Device SDK.

We recommend removing the standalone Device SDK when using the DocV SDK to avoid duplication or version conflicts.

If you choose to include both, use Device SDK **v4.11.1** or a later v4.11.x release. The DocV SDK's `Package.swift` accepts versions from 4.11.1 up to, but not including, 4.12.0, so Swift Package Manager can't resolve a Device SDK version outside that range.

## Step 1: Generate a transaction token and configure the Capture App

To initiate the verification process, generate a transaction token (`docvTransactionToken`) by calling the RiskOS Evaluation endpoint. We strongly recommend that customers generate this token via a server-to-server API call and then pass it to the DocV SDK to ensure the security of their API key and any data they send to Socure. 

### Call the Evaluation endpoint

1. From your backend, make a `POST` request to the [`/api/evaluation`](https://help.socure.com/riskos/reference/postevaluation) endpoint. Use the endpoint for your environment:

| Environment | Endpoint                                           |
|-------------|----------------------------------------------------|
| Sandbox     | `https://riskos.sandbox.socure.com/api/evaluation` |
| Production  | `https://riskos.socure.com/api/evaluation`         |

Send your RiskOS API key as a Bearer token in the `Authorization` header, and specify the following information in the `data.individual.docv.config` object:

| Parameter   | Required | Description                                                                                                                                                                                                                                                                                                                                                     |
|------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `language`       | Optional     | Determines the [language package](https://help.socure.com/riskos/docs/language-options) for the UI text on the Capture App.  <br/><br/> **Note**: Socure can quickly add support for new language requirements. For more information, contact [support@socure.com](mailto:support@socure.com). |
| `use_case_key`   | Optional     | Deploys a customized Capture App flow on a per-transaction basis. Replace the `customer_use_case_key` value with the name of the flow you created in [RiskOS](https://help.socure.com/riskos/docs/capture-app). <br/><br/> - If this field is empty, the Capture App will use the flow marked as **Default** in RiskOS. <br/> - If the value provided is incorrect, the SDK will return an `Invalid Request` error. |

>Note: We recommend including as much consumer PII in the body of the request as possible to return the most accurate results. For the complete server-to-server flow and the full `docv.config` payload for every flow type, see [DocV Integration](https://help.socure.com/riskos/docs/docv-sdk-integration) in the RiskOS documentation.

```bash
curl --location 'https://riskos.socure.com/api/evaluation' \
--header 'accept: application/json' \
--header 'authorization: Bearer YOUR_API_KEY' \
--header 'content-type: application/json' \
--header 'X-API-Version: 2025-01-01.orion' \
--data-raw '{
  "id": "onb-12345",
  "workflow": "consumer_onboarding",
  "timestamp": "2025-01-08T14:57:42.089Z",
  "data": {
    "individual": {
      "id": "9876543",
      "given_name": "John",
      "family_name": "Doe",
      "national_id": "000-10-0007",
      "date_of_birth": "2002-07-28",
      "email": "johndoe@gmail.com",
      "phone_number": "+13475550100",
      "docv": {
        "config": {
          "use_case_key": "customer_use_case_key",
          "language": "en-us"
        }
      },
      "address": {
        "line_1": "200 Key Square St",
        "locality": "Brownsville",
        "major_admin_division": "TN",
        "country": "US",
        "postal_code": "38012"
      }
    }
  }
}'
```

2. When you receive the API response, collect the `docvTransactionToken` from the enrichment in the `data_enrichments` array whose `enrichment_provider` is `SocureDocRequest` (`data_enrichments[n].response.data.docvTransactionToken`). This value is required to initialize the DocV iOS SDK. Match on `enrichment_provider`, because `enrichment_name` can differ between workflows.

    Also store the `eval_id` in your backend. You need it to match the verification results to this evaluation in [Step 3](#step-3-receive-the-verification-results).

```json
{
  "id": "onb-12345",
  "workflow": "consumer_onboarding",
  "eval_id": "500c6b88-9f5c-4d62-9422-163a59a343fe",
  "decision": "REVIEW",
  "status": "ON_HOLD",
  "eval_status": "evaluation_paused",
  "data_enrichments": [
    {
      "enrichment_name": "SocureDocRequest",
      "enrichment_endpoint": "https://service.socure.com/api/5.0/documents/request",
      "enrichment_provider": "SocureDocRequest",
      "status_code": 200,
      "response": {
        "data": {
          "docvTransactionToken": "78d1c86d-03a3-4e11-b837-71a31cb44142",
          "eventId": "78d1c86d-03a3-4e11-b837-71a31cb44142",
          "qrcode": "data:image/png;base64,iVBO......K5CYII=",
          "url": "https://verify.socure.com/#/dv/78d1c86d-03a3-4e11-b837-71a31cb44142"
        },
        "referenceId": "aacdc975-0eb8-428d-9954-b42aab67f85f"
      }
    }
  ]
}
```

>Note: The `REVIEW` decision in this response is not the final decision. RiskOS pauses the evaluation (`ON_HOLD`, `evaluation_paused`) until the consumer completes the document capture, then resumes it and returns the final decision. See [Step 3](#step-3-receive-the-verification-results). A paused evaluation returns HTTP `201` instead of `200`, so treat both status codes as success.

## Step 2: Add the DocV iOS SDK 

You can use either CocoaPods or Swift Package Manager to add the DocV iOS SDK to your project. Depending on the dependency manager you want to use, follow the steps in one of the installation sections below. We recommend Swift Package Manager, because new SDK versions are no longer published to CocoaPods.

### CocoaPods (deprecated in Nov 2026)

>Note: The last DocV iOS SDK version available through CocoaPods is 5.7.1. To get later versions, use [Swift Package Manager](#swift-package-manager).

To install the DocV iOS SDK using CocoaPods, add the following to your Podfile:

```
pod 'SocureDocV'
```

Next, install the Pod from the terminal:

```
pod install
```

>Note: You must close the project and open the `xcworkspace` file after you install the pod for it to properly reflect in your project.

### Swift Package Manager

To install the DocV iOS SDK using Swift Package Manager, add the following package repository URL:

```
https://github.com/socure-inc/socure-docv-sdk-ios
```

### Camera permissions

The DocV SDK requires camera permissions to capture identity documents. Upon the first invocation of the SDK, the app will request camera permission from the user.  If the app does not already use the camera, you must add the following to the app’s `Info.plist file`:

| Key                                | Type   | Value                                                                                       |
|------------------------------------|--------|---------------------------------------------------------------------------------------------|
| Privacy - Camera Usage Description | String | "This application requires use of your camera in order to capture your identity documents." |

>Note: We recommend you check for camera permission before calling the DocV SDK launch API. 

### Import SocureDocV

Add the following line to import the SocureDocV SDK into the view controller:

```swift
import SocureDocV
```

### Initialize and launch the SDK

To enable the DocV SDK functionality, add the following code to your app: 

```swift
func onButtonTapped() {
    let options = SocureDocVOptions(
        publicKey: "da3e907d-c5dd-41cb-80ee-xxxxxxxxxxxx",
        docvTransactionToken: "78d1c86d-03a3-4e11-b837-71a31cb44142",
        presentingViewController: self,
        useSocureGov: false
    )

    SocureDocVSDK.launch(options) { 
        (result: Result<SocureDocVSuccess, SocureDocVFailure>) in
        
        switch result {
        case .success(let success):
            print(
                "Flow succeeded: \(success)"
            )
        case .failure(let failure):
            print(
                "Flow failed due to \(failure)"
            )
        }
    }
}
```

#### `options` parameters

The following table lists the `options` parameters: 

| Parameter                 | Type            | Description                                                                                                                                                              |
|---------------------------|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `publicKey`                | String          | The unique SDK key obtained from [RiskOS](https://riskos.socure.com/accounts/developers/sdk-keys) used to authenticate the SDK.                                                |
| `docvTransactionToken`     | String          | The transaction token retrieved from the API response of the [`/api/evaluation`](https://help.socure.com/riskos/reference/postevaluation) endpoint. Required to initiate the document verification session. |
| `presentingViewController` | UIViewController| The current view controller (referred to as `self`) that will present the SDK's user interface.                                                                           |
| `useSocureGov`             | Bool            | Optional boolean flag indicating whether to use the GovCloud environment. Defaults to `false`. Set to `true` to route requests to GovCloud. Only applicable for customers provisioned in the GovCloud environment.  |

>Note: Existing ID+ customers use the SDK key from Admin Dashboard and the `docvTransactionToken` from the Document Request endpoint. See [Existing ID+ customers](#existing-id-customers).

### Handle the response

Your app can receive response callbacks using a `switch` statement when the flow either completes successfully or returns with an error. The SDK handles both responses through the `SocureDocVSDK.launch(options)` function. 

#### Success

If the consumer successfully completes the flow and the captured images are uploaded to Socure's servers, the `result` is `.success` and a message containing the `deviceSessionToken` is printed. This result contains a `deviceSessionToken`, a unique identifier for the session that can be used for accessing device details about the specific session.

```swift
public struct SocureDocVSuccess {
    public let deviceSessionToken: String?
}
```

#### Failure

If the consumer exits the flow without completing it or an error occurs, the `result` is `.failure` and a message is printed with the `deviceSessionToken` and specific error details.

```swift
public struct SocureDocVFailure: Error {
    public let error: SocureDocVError
    public let deviceSessionToken: String?
}
```

When the DocV SDK returns a failure, it provides a `SocureDocVError` enum with specific error cases relevant to the Capture App flow:

```swift
public enum SocureDocVError {
    case sessionInitiationFailure
    case sessionExpired
    case invalidPublicKey
    case invalidDocvTransactionToken
    case noInternetConnection
    case documentUploadFailure
    case userCanceled
    case consentDeclined
    case guardianConsentDeclined
    case cameraPermissionDeclined
    case unknown
}
```

The following table lists the error values that can be returned by the `SocureDocVError` enum:  


| Enum Case                      | Error Description                                           |
|---------------------------------|-------------------------------------------------------------|
| `sessionInitiationFailure`     | Failed to initiate the session                              |
| `sessionExpired`               | Session expired                                             |
| `invalidPublicKey`            | Invalid or missing SDK key                           |
| `invalidDocvTransactionToken`| Invalid transaction token                                   |
| `noInternetConnection`        | No internet connection                                      |
| `documentUploadFailure`       | Failed to upload the documents                              |
| `userCanceled`                 | Scan canceled by the user                                   |
| `consentDeclined`              | Consent declined by the user                                            |
| `guardianConsentDeclined`    | Consent declined by the guardian      |
| `cameraPermissionDeclined`    | Permissions to open the camera declined by the user      |
| `unknown`                       | Unknown error                                               |

>Note: The SocureDocV SDK also returns the backend API error codes and messages as received (for example, **access denied** or **insufficient permission**).

## Step 3: Receive the verification results 

After the consumer finishes the document capture and upload process, RiskOS resumes the paused evaluation and produces the final decision. The `.success` result from the SDK only confirms that the images were uploaded. It does not contain the verification decision. Get the results from RiskOS in one of these ways:

- **Webhook (recommended)**: In RiskOS, go to **Developer Workbench > Webhooks** and subscribe to the `evaluation_completed` and `case_notes_added` events. RiskOS sends `evaluation_completed` when the evaluation finishes, and `case_notes_added` as the consumer progresses through the capture. The DocV verification results are in the `data_enrichments` array of the payload. For endpoint setup, see [Configure Webhooks in RiskOS](https://help.socure.com/riskos/docs/webhooks).
- **GET request**: From your backend, call the [`/api/evaluation/{eval_id}`](https://help.socure.com/riskos/reference/getevaluation) endpoint with the `eval_id` that you stored in [Step 1](#call-the-evaluation-endpoint). Use this method if you cannot host a webhook endpoint, or to reconcile a missed webhook.

```bash
curl --request GET \
--url 'https://riskos.socure.com/api/evaluation/YOUR_EVAL_ID' \
--header 'authorization: Bearer YOUR_API_KEY'
```

Both methods return the same result schema. Match the `eval_id` to the evaluation that you stored, then route the consumer on the top-level workflow `decision` (`ACCEPT`, `REJECT`, or `REVIEW`). Do not route on the nested DocV module decision (`documentVerification.decision.value`).

```json
{
  "event_type": "evaluation_completed",
  "event_id": "3b31289c-2d4a-4107-80bc-dda63031d5a0",
  "event_at": "2025-07-17T01:20:01Z",
  "data": {
    "eval_id": "500c6b88-9f5c-4d62-9422-163a59a343fe",
    "id": "onb-12345",
    "workflow": "consumer_onboarding",
    "eval_status": "evaluation_completed",
    "decision": "ACCEPT",
    "status": "CLOSED",
    "data_enrichments": [
      {
        "enrichment_name": "Socure Document Verification",
        "enrichment_endpoint": "https://service.socure.com/api/5.0/documents/verify",
        "enrichment_provider": "Socure",
        "status_code": 200,
        "response": {
          "referenceId": "ed6a5077-b272-4a75-8c21-b284e10927cd",
          "documentVerification": {
            "decision": {
              "name": "standard",
              "value": "accept"
            },
            "reasonCodes": [
              "I831",
              "I836"
            ],
            "documentType": {
              "type": "Drivers License",
              "country": "USA",
              "state": "NY"
            }
          }
        }
      }
    ]
  }
}
```

For the full payload, the `case_notes_added` progress events, and decision handling, see [Receive DocV Results](https://help.socure.com/riskos/docs/docv-receive-results) in the RiskOS documentation.

## Existing ID+ customers

This section is only for existing customers who integrated DocV through ID+. If you are starting a new integration, follow the RiskOS steps above.

For ID+ integrations, use the steps below instead of the RiskOS prerequisites, Step 1, and Step 3. [Step 2: Add the DocV iOS SDK](#step-2-add-the-docv-ios-sdk) is the same for both integrations.

### ID+ prerequisites

- Get a valid [ID+ key from Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/id-plus-keys) to authenticate API requests.
- Get a valid [SDK key from Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/sdk-keys) to initialize and authenticate the DocV iOS SDK.
- Add your IP address to the [allowlist in Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/allowlist).

### Generate a transaction token with the Document Request endpoint

1. From your backend, make a `POST` request to the [`/documents/request`](https://developer.socure.com/reference#tag/Predictive-Document-Verification/operation/DocumentRequestV5) endpoint specifying the following information in the `config` object:

| Parameter   | Required | Description                                                                                                                                                                                                                                                                                                                                                     |
|------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `language`       | Optional     | Determines the language package for the UI text on the Capture App.  <br/><br/> **Note**: Socure can quickly add support for new language requirements. For more information, contact [support@socure.com](mailto:support@socure.com). |
| `useCaseKey`     | Optional     | Deploys a customized Capture App flow on a per-transaction basis. Replace the `customer_use_case_key` value with the name of the flow you created in [Admin Dashboard](https://developer.socure.com/docs/sdks/docv/capture-app/customize-capture-app). <br/><br/> - If this field is empty, the Capture App will use the flow marked as **Default** in Admin Dashboard. <br/> - If the value provided is incorrect, the SDK will return an `Invalid Request` error. |

>Note: We recommend including as much consumer PII in the body of the request as possible to return the most accurate results. 

```bash
curl --location 'https://service.socure.com/api/5.0/documents/request' \
--header 'Content-Type: application/json' \
--header 'Authorization: SocureApiKey a182150a-363a-4f4a-xxxx-xxxxxxxxxxxx' \
--data '{
  "config": {
    "useCaseKey": "customer_use_case_key"
  },
  "firstName": "Dwayne",
  "surName": "Denver",
  "dob": "1975-04-02",
  "mobileNumber": "+13475550100",
  "physicalAddress": "200 Key Square St",
  "physicalAddress2": null,
  "city": "Brownsville",
  "state": "TN",
  "zip": "38012",
  "country": "US"
}'
```

2. When you receive the API response, collect the `docvTransactionToken`. This value is required to initialize the DocV iOS SDK and fetch the DocV results. 

```json
{
  "referenceId": "123ab45d-2e34-46f3-8d17-6f540ae90303",
    "data": {
      "eventId": "zoYgIxEZUbXBoocYAnbb5DrT",
      "customerUserId": "121212",
      "docvTransactionToken" : "78d1c86d-03a3-4e11-b837-71a31cb44142", 
      "qrCode": "data:image/png;base64,iVBO......K5CYII=",
      "url": "https://verify-v2.socure.com/#/t/c5e71062-26d5-478c-8441-b434fcc565d0"
    }
}
```

3. Pass the `docvTransactionToken` and your Admin Dashboard SDK key to the SDK as described in [Initialize and launch the SDK](#initialize-and-launch-the-sdk).

### Fetch the verification results with ID+

When the consumer successfully completes the document capture and upload process, call the ID+ endpoint to fetch the results. See the [API Reference documentation](https://developer.socure.com/reference#tag/ID+/operation/ID+) on DevHub for more information.

## External dependencies

| Dependency | Used by | Details |
|------------|---------|---------|
| RiskOS Evaluation API (`riskos.socure.com`, `riskos.sandbox.socure.com`) | Your backend | Creates the evaluation, returns the `docvTransactionToken` ([Step 1](#step-1-generate-a-transaction-token-and-configure-the-capture-app)), and returns the verification results ([Step 3](#step-3-receive-the-verification-results)). Requires a RiskOS API key. |
| Socure SDK binary host (`sdk.socure.com`) | Swift Package Manager | Hosts the `SocureDocV.xcframework` zip that `Package.swift` downloads and verifies with a checksum. Your build machine must be able to reach this host. |
| Device Risk SDK ([`socure-sigmadevice-sdk-ios`](https://github.com/socure-inc/socure-sigmadevice-sdk-ios)) | Swift Package Manager | Provides the `DeviceRisk` module. `Package.swift` accepts versions from 4.11.1 up to, but not including, 4.12.0. |
| Socure DocV services | The SDK at runtime | The SDK connects to Socure to start the capture session and upload the documents. Requires your SDK key and a network connection on the device. |

## Run locally

The `SampleApp` folder contains a sample app that launches the DocV SDK.

Before you start, make sure you have the following:

- macOS with Xcode 16.1 or later.
- An iPhone or iPad with iOS 15.6 or later. The iOS Simulator has no camera, so you cannot complete a document capture on it.
- An Apple Developer team to sign the app.
- An SDK key and a `docvTransactionToken` from [Step 1](#step-1-generate-a-transaction-token-and-configure-the-capture-app). Each token supports one capture session, so generate a new token for each run.

To run the sample app:

1. Clone the repository:

    ```bash
    git clone https://github.com/socure-inc/socure-docv-sdk-ios.git
    cd socure-docv-sdk-ios
    ```

2. Open the project. Xcode resolves the package dependencies when the project opens.

    ```bash
    open SampleApp/SampleApp.xcodeproj
    ```

3. In `SampleApp/SampleApp/ViewController.swift`, replace `REPLACE_KEY_HERE` with your SDK key and `REPLACE_TOKEN_HERE` with your `docvTransactionToken`.
4. Select the `SampleApp` target, open **Signing & Capabilities**, and select your team. If Xcode reports that the bundle identifier is not available, change `com.socure.sampleapp` to a unique value.
5. Select your device and choose **Product > Run**.
6. Tap **Start** to launch the capture flow. When the flow ends, the status label shows the result.

### Run the sample app with your local changes

The sample app uses the published `socure-docv-sdk-ios` package from GitHub, not your working copy. To test changes to `Package.swift`, open `SampleApp/SampleApp.xcworkspace` and drag the repository root folder (the folder that contains `Package.swift`) into the Project navigator, at the top level next to the `SampleApp` project. Xcode then uses your local package instead of the published one. Do not commit this change to the workspace.

The repository root folder must be named `socure-docv-sdk-ios`, as it is when you clone it with the command above. Xcode matches a local package to the published one by folder name, so under any other name it reports that the package identity doesn't match.

## Run tests

The tests in the `Tests` folder check this package against this README. They run in the iOS Simulator and fail when:

- the framework that `Package.swift` downloads isn't the version that its URL names.
- `SocureDocVError` has a case that the enum under [Failure](#failure) doesn't list, or the other way round.
- the code in [Initialize and launch the SDK](#initialize-and-launch-the-sdk) no longer compiles, or the `SocureDocVOptions` defaults no longer match the [`options` parameters](#options-parameters).

Before you start, make sure you have the following:

- macOS 14.5 or later with Xcode 16.1 or later, selected as the active developer directory. The Command Line Tools alone aren't enough. If `xcodebuild -version` fails, install Xcode and run `sudo xcode-select -s /Applications/Xcode.app`.
- An iOS simulator runtime. If none is installed, run `xcodebuild -downloadPlatform iOS`.
- Network access to `github.com` and `sdk.socure.com`. Swift Package Manager downloads the DocV and Device Risk SDKs during the build.

You don't need credentials, because the tests don't call Socure's APIs.

To run the tests:

1. List the available iPhone simulators and pick one by name, for example `iPhone 17`:

    ```bash
    xcrun simctl list devices available iPhone
    ```

2. From the repository root, build the package and the sample app. Both commands must end with `** BUILD SUCCEEDED **`.

    ```bash
    xcodebuild -scheme SocureDocV -destination 'generic/platform=iOS Simulator' build
    xcodebuild -project SampleApp/SampleApp.xcodeproj -scheme SampleApp -destination 'generic/platform=iOS Simulator' build
    ```

3. Run the tests in the simulator that you picked. Replace `iPhone 17` with its name.

    ```bash
    cd Tests
    xcodebuild test -scheme SocureDocVTests-Package -destination 'platform=iOS Simulator,name=iPhone 17'
    ```

    When every test passes, the command ends with `** TEST SUCCEEDED **` and exits with status 0. When a test fails, it prints the failure, ends with `** TEST FAILED **`, and exits with a non-zero status.

4. To check the full flow, [run the sample app](#run-locally) on a device and complete a document capture.
