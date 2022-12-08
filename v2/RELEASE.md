# Release Notes

The Predictive Document Verification iOS SDK provides a framework to add image capture and upload services to your mobile application.

## 2.2.2

# Enhancements

- None.

# Bug Fixes

- Corrected UI alignment issues for the Consent and Terms of Service screen.

# Known Issues

- None.


## 2.2.1

# Enhancements

- Added a notice and consent feature that is displayed prior to the initiation of the document capture and upload process on the Capture App. The consumer must either click **I Agree** to provide consent and begin the document capture flow, or **I Decline** to decline consent and cancel the transaction. If the consumer declines to provide consent, the document capture flow is terminated and the Socure DocV SDK returns an error.
- Added color, font, and text size customization options to the **I Agree** and **I Decline** buttons on the notice and consent feature.  
- Removed mandatory requirement to set the public key in `info.plist`. 
- Deprecated `Imageuploader(_ clientApiKey:String)`. The public key must be added to your application in one of the following methods before the first scan is attempted: 
    - Configured in `info.plist`
    - Set in the function `func setSocureSdkKey(_ publicKey: String)`


# Bug Fixes

- None.

# Known Issues

- None.


## 2.2.0

# Enhancements

- Added a notice and consent feature that is displayed prior to the initiation of the document capture and upload process on the Capture App. The consumer must either click **I Agree** to provide consent and begin the document capture flow, or **I Decline** to decline consent and cancel the transaction. If the consumer declines to provide consent, the document capture flow is terminated and the Socure DocV SDK returns an error.
- Removed mandatory requirement to set the public key in `info.plist`. The user can either set the public key in `info.plist` or call the following method  to set the key: 
      `func setSocureSdkKey(_ publicKey: String)`
- Deprecated `Imageuploader(_ clientApiKey:String)`. The public key can now be configured using the new method or using `Info.plist`.  

# Bug Fixes

- None.

# Known Issues

- None.



## 2.1.4

# Enhancements

- None. 

# Bug Fixes

- Fixed an issue with disabling the tutorialView and the help card during the ID and selfie image capture process. 
- Fixed an issue with DocV iOS SDK crashes. 
- Fixed a bug with manual and auto capture errors that occur when the camera flash is enabled. 

# Known Issues

- None.



## 2.1.3

# Enhancements
   * Improved image preview for manual capture
   * Improved error handling
        * DocumentScanError is not sent if barcode/ MRZ data extraction fails
        * Added the following to DocScanResult:
            * dataExtracted - true/false (if barcode / MRZ data is extracted, this is set to true)
            * captureType - integer where 0 is Auto and 1 is Manual capture
   * Delinked the Device Risk SDK from DocV SDK  
# Bug Fixes
   * Fixed barcode extraction from newer driver's licenses
   * Fixed SDK version references 
   * Fixed issues using native camera 
# Known Issues
   * None
