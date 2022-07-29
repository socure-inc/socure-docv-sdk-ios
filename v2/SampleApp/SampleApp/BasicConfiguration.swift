//
//  Constants.swift
//  InterfaceDesignApp
//
//  Created by Samson on 12/12/18.
//  Copyright © 2018 Samson. All rights reserved.
//

import UIKit

struct Colors {
    
    let GradientButtonFirstColour = "4450dd"
    let GradientButtonSecondColour = "7988f0"
    
    let manualGradSignViewTop = "00c2ff"
    let manualGradSignViewBottom = "00e3ff"
    
    let autofilGradSignViewTop = "4450dd"
    let autofilGradSignViewBottom = "7988f0"
    
    let tabBarUnhighlight = "2e2e2e"
    
    let rejectedColor = "ffa5ac"
    let approvedColor = "d4ffa6"
}

public struct ScoreKeys {
    static let nameSigma = "sigma"
    static let riskScoreThresholdRed = 0.97
    static let riskScoreThresholdOrange = 0.9
    static let scoreEmpty = 100.0
}

public struct DefaultKeys {
    static let assessmentFlow = "assessment_flow"
    static let privacyPreference  = "privacy_preference_license_passport"
    static let documentBlur  = "document_blur"
    static let galleryPassport  = "allow_gallery" //allow_gallery
    static let manualCaptureLicense  = "only_manual_capture" //only_manual_capture
    static let orientation  = "orientation"
    static let showCropper  = "show_cropper" //show_cropper
    static let enableLevellingLicense  = "enable_levelling" //enable_levelling
    static let enableFlashCaptureLicense  = "enable_flash_capture" //enable_flash_capture
    static let enableManualOverlayLicense  = "enable_manual_overlay"
    static let enableInitialOverlayLicense  = "enable_initial_overlay"
    static let enableGlareDetectionLicense  = "enable_glare_detection"
    static let enableFocusDetectionLicense  = "enable_focus_detection"
    static let enableFaceDetectionLicense  = "enable_face_detection"
    static let enableFaceCheckerLicense  = "face_detection"
    static let captureIntensity  = "capture_intensity"
    static let docTimeOut  = "manual_timeout"
    static let enableHelp = "enable_help"
    //  static let docTimeOutLicense  = "DocumentTimeoutLicense"
    static let manualCaptureSelfie  = "selfie_manual_capture"
    static let selfieTimeout  = "selfie_manual_timeout"
    static let blurThreshold  = "selfie_blur_threshold"
    static let faceMotion  = "selfie_face_motion"
    static let eyeMotion  = "selfie_eye_motion"
    static let roiFocus  = "selfie_roi_focus"
    static let eyeIntensity  = "selfie_eye_intensity"
    static let faceDetection  = "selfie_eye_motion"
    static let barCodeDetection  = "bar_code_detection"
    static let selfieShowConfirmation  = "selfie_showconfirmation_screen"
    static let selfieManualOverlay  = "selfie_manual_overlay"
    static let selfieEnableHelp  = "selfie_enable_help"
    static let selfieInitialOverlay  = "selfie_initial_overlay"
    
}

public struct SocureSdkErrors{
    static let passportScanError  = "Passport Scan WithError"
    static let licenseFrontScanError = "License Front Scan WithError";
    static let liocenseBackScanError = "License Back Scan WithError";
    static let selfieScanError = "Selfie Scan Error";
    static  let documentUploadError = "Document Upload Error";
    static  let barcodeDataError = "Barcode data is not extracted";
    static let mrzDataError = "MRZ Data is not extracted";
}
