# Release Notes

The Socure Document Verification iOS SDK provides a framework to add image capture and upload services to your mobile application.

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
