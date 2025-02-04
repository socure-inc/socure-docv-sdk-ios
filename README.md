# Predictive DocV iOS SDK v5

Learn how to quickly integrate with the Predictive Document Verification (DocV) iOS SDK v5.

>Note: The Digital Intelligence SDK is required for all DocV iOS SDK v5 integrations. For more information, see [Digital Intelligence iOS SDK Quick Start Guide](https://developer.socure.com/docs/sdks/digital-intelligence/ios-sdk). 

## Table of Contents

- [Getting started](#getting-started)
- [Step 1: Generate a transaction token](#step-1-generate-a-transaction-token-and-configure-the-capture-app)
  - [Call the Document Request endpoint](#call-the-document-request-endpoint)
- [Step 2: Add the DocV iOS SDK](#step-2-add-the-docv-ios-sdk)
  - [CocoaPods](#cocoapods)
  - [Swift Package Manager](#swift-package-manager)
  - [Camera permissions](#camera-permissions)
  - [Import SocureDocV](#import-socuredocv)
  - [Initialize and launch the SDK](#initialize-and-launch-the-sdk)
  - [Handle the response](#handle-the-response)
- [Step 3: Fetch the verification results](#step-3-fetch-the-verification-results)

## Getting started

Before you begin, ensure you have the following: 

- Install the latest version of the [Digital Intelligence iOS SDK](https://developer.socure.com/docs/sdks/digital-intelligence/ios-sdk). 
- Get a valid [ID+ key from Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/id-plus-keys) to authenticate API requests.
- Get a valid [SDK key from Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/sdk-keys) to initialize and authenticate the DocV iOS SDK.
- Add your IP address to the [allowlist in Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/allowlist).
- Check that your development environment meets the following requirements:
    - Xcode version 14.1+
    - Support for iOS 13 and later

## Step 1: Generate a transaction token and configure the Capture App

To initiate the verification process, generate a transaction token (`docvTransactionToken`) by calling the Document Request endpoint v5. We strongly recommend that customers generate this token via a server-to-server API call and then pass it to the DocV SDK to ensure the security of their API key and any data they send to Socure. 

### Call the Document Request endpoint

1. From your backend, make a `POST` request to the [`/documents/request`](https://developer.socure.com/reference#tag/Predictive-Document-Verification/operation/DocumentRequestV5) endpoint specifying the following information in the `config` object:

| Parameter   | Required | Description                                                                                                                                                                                                                                                                                                                                                     |
|------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `language`       | Optional     | Determines the language package for the UI text on the Capture App. Possible values are: <br/><br/> - Arabic: `ar` <br/> - Armenian: `hy` <br/> - Bengali: `bn` <br/> - Brazilian Portuguese: `pt-br` <br/> - Chinese (Simplified): `zh-cn` <br/> - Chinese (Traditional): `zh-tw` <br/> - English: `en` <br/> - French: `fr` <br/> - Haitian Creole: `ht` <br/> - Italian: `it` <br/> - Korean: `ko` <br/> - Polish: `pl-PL` <br/> - Russian: `ru` <br/> - Spanish (EU): `es` <br/> - Tagalog: `tl` <br/> - Urdu: `ur` <br/> - Vietnamese: `vi` <br/><br/> **Note**: Socure can quickly add support for new language requirements. For more information, contact [support@socure.com](mailto:support@socure.com). |
| `useCaseKey`     | Optional     | Deploys a customized Capture App flow on a per-transaction basis. Replace the `customer_use_case_key` value with the name of the flow you created in [Admin Dashboard](https://developer.socure.com/docs/sdks/docv/capture-app/customize-capture-app). <br/><br/> - If this field is empty, the Capture App will use the flow marked as **Default** in Admin Dashboard. <br/> - If the value provided is incorrect, the SDK will return an `Invalid Request` error. |

>Note: We recommend including as much consumer PII in the body of the request as possible to return the most accurate results. 

```bash
curl --location 'https://service.socure.com/api/5.0/documents/request' \
--header 'Content-Type: application/json' \
--header 'Authorization: SocureApiKey a182150a-363a-4f4a-xxxx-xxxxxxxxxxxx' \
--data '{
  "config": {
    "useCaseKey": "customer_use_case_key", 
    ...
  }
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

## Step 2: Add the DocV iOS SDK 

You can use either CocoPods or Swift Package Manager to add the DocV iOS SDK to your project. Depending on the dependency manager you want to use, follow the steps in one of the installation sections below. 

### CocoaPods

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
        docVTransactionToken: "78d1c86d-03a3-4e11-b837-71a31cb44142",
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
| `publicKey`                | String          | The unique SDK key obtained from [Admin Dashboard](https://developer.socure.com/docs/admin-dashboard/developers/sdk-keys) used to authenticate the SDK.                                                |
| `docVTransactionToken`     | String          | The transaction token retrieved from the API response of the [`/documents/request`](https://developer.socure.com/reference#tag/Predictive-Document-Verification/operation/DocumentRequestV5) endpoint. Required to initiate the document verification session. |
| `presentingViewController` | UIViewController| The current view controller (referred to as `self`) that will present the SDK's user interface.                                                                           |
| `useSocureGov`             | Bool            | A Boolean flag indicating whether to use the GovCloud environment. It defaults to `false`. This is only applicable for customers provisioned in the SocureGov environment. |

### Handle the response

Your app can receive response callbacks using a `switch` statement when the flow either completes successfully or returns with an error. The SDK handles both responses through the `SocureDocVSDK.launch(options)` function. 

#### Success

If the consumer successfully completes the flow and the captured images are uploaded to Socure's servers, the `result` is `.success` and a message containing the `deviceSessionToken` is printed. This result contains a `deviceSessionToken`, a unique identifier for the session that can be used for accessing device details about the specific session.

```
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
    case invalidDocVTransactionToken
    case noInternetConnection
    case documentUploadFailure
    case userCanceled
    case consentDeclined
    case cameraPermissionDeclined
    case unknown
}
```

The following table lists the error values that can be returned by the `SocureDocVError` enum:  


| Enum Case                      | Error Description                                           |
|---------------------------------|-------------------------------------------------------------|
| `sessionExpired`               | Session expired                                             |
| `invalidPublicKey`            | Invalid or missing SDK key                           |
| `invalidDocVTransactionToken`| Invalid transaction token                                   |
| `noInternetConnection`        | No internet connection                                      |
| `documentUploadFailure`       | Failed to upload the documents                              |
| `userCanceled`                 | Scan canceled by the user                                   |
| `consentDeclined`              | Consent declined by the user                                            |
| `cameraPermissionDeclined`    | Permissions to open the camera declined by the user      |
| `unknown`                       | Unknown error                                               |

>Note: The SocureDocV SDK also returns the backend API error codes and messages as received (for example, **access denied** or **insufficient permission**).

## Step 3: Fetch the verification results 

When the consumer successfully completes the document capture and upload process, call the ID+ endpoint fetch the results. See the [API Reference documentation](https://developer.socure.com/reference#tag/ID+/operation/ID+) on DevHub for more information. 