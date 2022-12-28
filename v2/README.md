# Document Verification iOS SDK

The Document Verification iOS SDK provides a framework to add image capture and upload services to your mobile application.

>Note: All SDK v2 integrations should be updated to version 2.2.2 or above to meet compliance requirements. Document verification services will be disabled for older SDK versions soon.

## Minimum requirements

| Feature                           | Minimum Requirements |
| --------------------------------- | -------------------- |
| Document and Selfie Capture       | iOS 12 and above     |
| Barcode Data Extraction on Device | iOS 12 and above     |
| MRZ Data Extraction on Device     | iOS 13 and above     |

| IDE   | Minimum Requirements |
| ----- | -------------------- |
| XCode | 11.4+                |

**Note:** Contact Technical Support if you compile with an earlier XCode version.

## Installation

You can manually download and install the Document Verification iOS SDK; however for ease and accuracy, we strongly recommend that you use the CocoaPods utility.

### Install the DocV iOS SDK through CocoaPods

To install the DocV iOS SDK, add the following to your podfile:

```
# Pods for SocureSdkDemo
    pod 'SocureSdk', :git => 'https://github.com/socure-inc/socure-docv-sdk-ios'

```

After you install the DocV iOS SDK, be sure to update your pods from the terminal:

```
pod install
```

**Note:** Close the project and open the xcworkspace file in the project after you update the pods in order to rebuild the project.

## Configuration and Usage 

For instructions on how to configure the SDK, see the [iOS SDK Documentation](https://developer.socure.com/guide/iossdk) on DevHub.



