# Document Verification iOS SDK

The Socure Document Verification SDK provides a framework to add image capture and upload services to your mobile application.

This guide covers integration with iOS.

| Feature                           | Minimum Requirements |
| --------------------------------- | -------------------- |
| Document and Selfie Capture       | iOS 12 and above     |
| Barcode Data Extraction on Device | iOS 12 and above     |
| MRZ Data Extraction on Device     | iOS 13 and above     |

| IDE                           | Minimum Requirements |
| --------------------------------- | -------------------- |
| XCode       | 11.4+    |

**Note:** Please reach out to support if you are compiling it at an earlier XCode version.


Pre-requisite: [**Guide: How to set up Cocoapods**](https://guides.cocoapods.org/using/getting-started.html)


**Step 1: Install Socure SDK using CocoaPods**

The SDK can be added to the project by adding the following to your Podfile:

```
  # Pods for SocureSdkDemo
    pod 'SocureSdk', :git => 'git@github.com:socure-inc/socure-docv-sdk-ios.git'
```
Update your pods from the terminal

```
pod install
```
Please make sure to close the project and open the xcworkspace file in the project again after updating the pods and rebuild the project. 


**Step 2: Add API Keys**

You would need to extract your SDK key from the Socure admin dashboard and use the same in the info.plist file of your application.
```
<key>socurePublicKey</key>
<string>xxyyzz</string>
```


**Step 3: Add Permissions for Camera and Location Use**

Add the following permissions to info.plist:

| Feature  | Key                                              
| -------- | ------------------------------------------------ 
| Camera   | Privacy - Camera Usage Description               

**Step 4: Import SDK into the View Controller**

Import the SDK in the View Controller.

**Step 5: Deploy Extension**

Deploy the following interfaces for Image, Barcode, MRZ, and Upload Callback in the required view controllers.

| Feature         | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| ImageCallback   | For post image handling and previewing the image using the byte array. |
| BarcodeCallback | For reading the barcode data.                                          |
| MRZCallback     | For reading the MRZ data.                                              |
| UploadCallback  | For post upload handling on success.                                                                       |

Deploy the extension for interfaces in the controllers where the action is to be performed.

```
extension ViewController :ImageCallback,UploadCallback,BarcodeCallback,MRZCallback
{
	func handleMRZData(mrzData: MrzData?) {...}

	func handleBarcodeData(barcodeData: BarcodeData?) {...}

	func documentUploadFinished(uploadResult: UploadResult) {...}

	func documentUploadFailed(failureMessage: String, statusCode: Int) {...}

	func documentFrontCallBack(docScanResult: DocScanResult) {...}

	func documentBackCallBack(docScanResult: DocScanResult) {...}

	func selfieCallBack(selfieScanResult: SelfieScanResult) {...}

	func onScanCancelled() {...}

	func onError(errorType: SocureSDKErrorType, errorMessage: String) {...}
}

```

ImageCallback interface Methods:

```
func documentFrontCallBack(docScanResult: DocScanResult)

func documentBackCallBack(docScanResult:DocScanResult)

func selfieCallBack(SelfieScanResult:SelfieScanResult)

func onScanCancelled()

```

BarcodeCallback interface Methods:

```
func handleBarcodeData(barcodeData: BarcodeData?)
```

MRZCallback interface Methods:

```
func handleMRZData(mrzData: MrzData?)
```

UploadCallback interface Methods:

```
func documentUploadFinished(uploadResult:UploadResult)
```

# Error Handling Method

Apart from these methods, all the callback will implement a common method for error handling, which shall be invoked for different error types.

```
func onError(errorType: SocureSDKErrorType, errorMessage: String) {..}
```

We have the following SocureSDKErrorType available as constants for understanding and deciding the course of action on each of these errors.

| Error                   | Description                                                                                    |
| ----------------------- | ---------------------------------------------------------------------------------------------- |
| DocumentScanFailedError | Handles the exception if the SDK is not able to retrieve a valid document image from auto capture. |
| SelfieScanFailedError   | Handles the exception if the SDK is not able to retrieve a valid selfie from the capture. |
| DocumentUploadError     | Handles the exception if there is an error while the document upload process                   |
| InternetConnection      | Handles the error for internet connection issues.                                              |
| Error                   | For any other errors in the processing.                                                                                               |


```
func onError(errorType: SocureSDKErrorType, errorMessage: String)
   {
        if(errorType.self == SocureSDKErrorType.DocumentScanFailedError)
        {
           //do something
        }
...
    }
```

**Notes:** 
DocumentScanError has been deprecated. Barcode/MRZ extraction status can now be obtained from dataExtracted variable in DocScanResult.
The onError method should only be added once in the particular controller implementation. If you add multiple callbacks to the extension and use Xcode to add the protocol stubs, it might add the error method multiple times. 


# Step 6: Request Camera Permissions
# 

Call `requestCameraPermission` using either `DocumentScanner` or `SelfieScanner` to request camera permissions from the user. Please note, `requestCameraPermissions` is a class function and should be called *before* the underlying ViewController that uses either `DocumentScanner` or `SelfieScanner`  is ever added to the view stack. 

Below is an examples of its proper usage. 

```
ModalViewController.swift

class ModalViewController: UIViewController {
    let d​ocScanner​ = DocumentScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.d​ocScanner​.initiateLicenseScan(ImageCallback: self, BarcodeCallback:self)
        .
        .
        . // continue your class declaration with ImageCallback and BarcodeCallback implementations
    }
```

```
ViewController.swift

class ViewController:UIViewController {
.
.
.
// Your class declaration above. Below is a function that opens ModalViewController modally 

@IBAction func didCaptureButton(sender:UIButton) {
    
    DocumentScanner.requestCameraPermissions { (permissionsGranted) in
        DispatchQueue.main.async {
            
            if (permissionsGranted) {
                
                let viewController = ModalViewController()
                self.present(viewController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title:
                            "Permission Error", message: "This application requires access to the camera to fuction. Please grant camera permission for the application", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                
                        }))
                        
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
}
```

**Step 7: Initialize Services**

Initialize the DocumentScanner, SelfieScanner, and ImageUploader services In Global:

```
let docScanner = DocumentScanner()
let selfieScanner = SelfieScanner()
let imageUploader = ImageUploader()
```

```
let imageUploader = ImageUploader(“Key”)
```

Initiate the License scan service:

```
docScanner.initiateLicenseScan(ImageCallback: self, BarcodeCallback: self)
//to initiate the license scan in sequence, it will automatically call the back scan for the license.

//To initiate the document scan one at a time
docScanner.initiateLicenseFrontScan(ImageCallback: self)
docScanner.initiateLicenseBackScan(ImageCallback: self, BarcodeCallback: self)
```

Initiate the Passport scan service:

```
docScanner.initiatePassportScan(ImageCallback: self, MRZCallback: self)
```

Initiate the Selfie scan service:

```
selfieScanner.initiateSelfieScan(ImageCallback: self)
```

Initiate the UploadLicense service:

```
imageUploader.uploadLicense(UploadCallback:UploadCallback, front:Data, back:Data, selfie:Data);
imageUploader.uploadLicense(UploadCallback:UploadCallback, front:Data, back:Data);
```

Initiate the UploadPassport service:

```
imageUploader.uploadPassport(UploadCallback:UploadCallback, front:Data, selfie:Data);
imageUploader.uploadPassport(UploadCallback:UploadCallback, front:Data);
```

**Image Byte Array for Upload or Preview**

To pass the image data for upload or to preview the captured image, use capture callback methods to get the `docScanResult` object.

To get the image byte array for upload, use the imageData value of the `docScanResult` object. You can convert the same data to an image for preview.

```
imageUploader.uploadPassport(uploadCallback: self, front:docScanResult.imageData!);
```

**Storing Image Data in local variable**

The image data should be stored for later use in the implementation as Data struct type.

```
var sampleData : Data?
sampleData = docScanResult.imageData!
```

**Capture Type**
The way image has been captured (whether auto or manual) can be known using 'captureType' in 'DocScanResult'. 
0 - Document was captured automatically
1 - Document was captured manually


**Dynamically Pass the Public Key for Image Upload**

The document upload is governed by a public key which can be stored in the info.plist of the application, however, if you want to dynamically fetch the key from your database using your own service, you can pass the key directly to the image uploader method as an argument. The key passed will override the configuration key in the application’s info.plist.

```
let imageUploader = ImageUploader(“Key”)
```

**Barcode/MRZ Data**

To get the Barcode/MRZ data in the callback class, you can use the variables of the respective object. Please note that these shall give you an optional value, you can unwrap the optional value using Optional Chaining method. If data is extracted from Barcode/MRZ, 'dataExtracted' boolean is set to true in 'DocScanResult' retuned in ImageCallback interface Methods.

```
func handleBarcodeData(barcodeData: BarcodeData?)
{
  barcodeData?.firstName
  barcodeData?.middleName
  barcodeData?.lastName
  barcodeData?.address
  barcodeData?.city
  barcodeData?.state
  barcodeData?.zipCode
  barcodeData?.issueDate
  barcodeData?.expirationDate
  barcodeData?.dob
  barcodeData?.documentNumber
}

func handleMRZData(mrzData: MrzData?)
{
  mrzData?.firstName
  mrzData?.surName
  mrzData?.fullName
  mrzData?.expirationDate
  mrzData?.dob
  mrzData?.documentNumber
  mrzData?.issuingCountry
}
```

# SDK Customizations

The SDK allows the following off-the-shelf customizations which can be toggled through the config.plist values. The package has three files that can be used to change or modify the colors, texts and other capture properties.

| File             | Description                                                                                         |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| Document.json    | Add this file in the project to change the display color and size of the capture components.|
| Document.strings | Add this file in the project to change the texts for the capture screen components.|
| config.plist     | Add this file in the project to change the capture properties as defined below.|

## Document Capture Customizations

| Property Name                    | Description                                                        | Allowed Values | Default |
| -------------------------------- | ------------------------------------------------------------------ | -------------- |:-------:|
| show_cropper                     | Displays the capture frame for documents.                          | Boolean        |   YES   |
| only_manual_capture              | To disable the auto-capture of documents.                          | Boolean        |   NO    |
| manual_timeout                   | Timeout after which the option for manual capture pops.            | Number >1      |   10    |
| document_showconfirmation_screen | Shows document preview from Socure to confirm the captured images. | Boolean        |   YES   |
| enable_flash_capture             | Enable the flash image capture.                                    | Boolean        |   NO    |
| enable_document_quality_checker  | Enables the document quality checks at capture                     | Boolean        |   YES   |
| enable_help                      | Shows a help button at the bottom for the additional help text.    | Boolean        |   YES   |
| barcode_check                    | Toggle the barcode check, if disabled, the SDK will stop looking for the barcode at the back of the document after 3 seconds, capturing only using the edge detection    | Boolean        |   YES   |

## Selfie Capture Customizations

| Property Name                  | Description                                                     | Allowed Values | Default |
| ------------------------------ | --------------------------------------------------------------- | -------------- |:-------:|
| selfie_manual_capture          | Disable the auto-capture.                                       | Boolean        |   NO    |
| selfie_manual_timeout          | Timeout after which the option for manual capture pops.         | Number >1      |   10    |
| selfie_showconfirmation_screen | Shows selfie preview from Socure to confirm.                    | Boolean        |   YES   |
| selfie_enable_help             | Shows a help button at the bottom for the additional help text. | Boolean        |   YES   |

## Document.json breakdown

### main_button

Controls the navigation bar icons and color 

### help
Controls the different tutorial images used, as well as the up/down caret image used. 

### manual_overlay
Controls the overlay UI, its different colors, fonts and overall opacity

### navigation_bar
Controls how the navigation bar is customized

### segmented_control
Controls how the segmented control is customized (visible only in debug mode)

### status_display
Controls how the countdown timer is displayed

### confirmation_display
Controls how visual elements of the confirmation screen are displayed

### dialog_alert
Controls the dialogue box element colors and styles


## Known Issues


- Certain text elements can overlay over other UI elements if the SDK is called modally under a modalPresentationStyle that doesn't cover the full screen. This is most noticeable with small screen devices like the iPhone SE. As a workaround, you can either adjust the text context or use a modalPresentationStyle that covers the full screen. 

- Calling the SDK modally in a way that allows for interactive dismissal of the view controller can result in the camera automatically turning off when the user cancels out from dismissing the view controller. At this time, we do not support this action and recommend that interactive dismissals of the SDK be disabled by adding the following code snippet to your code:

```
	if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
```

- Attempting to capture the back of an ID card that has a magnetic strip and a barcode against a dark background causes issues where the ID cannot be extracted from the environment.
