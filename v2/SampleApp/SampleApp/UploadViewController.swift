//
//  UploadViewController.swift
//  BareBonesDemo2
//
//  Created by Nicolas Dedual on 8/10/20.
//  Copyright © 2020 Socure Inc. All rights reserved.
//

import UIKit
import SocureSdk

class UploadViewController: UIViewController {
    
    @IBOutlet weak var documentLabel:UILabel?
    @IBOutlet weak var selfieLabel:UILabel?
    @IBOutlet weak var resultsLabel:UILabel?
    
    @IBOutlet weak var frontImageView:UIImageView?
    @IBOutlet weak var backImageView:UIImageView?
    @IBOutlet weak var selfieImageView:UIImageView?
    
    var frontImageData:Data?
    var backImageData:Data?
    var selfieImageData:Data?
    var isPassport = false
    
    @IBOutlet weak var uploadButton:UIButton?
    @IBOutlet weak var resultsTextView:UITextView?
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView?
    
    @IBOutlet weak var closeButton:UIButton?
    
    let imgUpload = ImageUploader()
    //The following method is deprecated
   //let imgUpload1 = ImageUploader("asdfdafdasfasdfdasfs")
    
    var uplaodResult: UploadResult?
    var isWithSeflie = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let front = frontImageData {
            
            frontImageView?.image = UIImage.init(data: front)
            if let back = backImageData {
                backImageView?.image = UIImage.init(data: back)
            }
            if  let selfie = selfieImageData {
            selfieImageView?.image = UIImage.init(data: selfie)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uploadButton?.isEnabled = false
        if let _ = frontImageData,
            let _ = selfieImageData {
            if isPassport || backImageData != nil {
                uploadButton?.isEnabled = true
            }
        } else {
            uploadButton?.isEnabled = false
        }
    }
    
    @IBAction func uploadDocument(sender:UIButton) {
        if uplaodResult != nil {
            self.imgUpload.uploadSelfie(UploadCallback: self, docUploadResult: uplaodResult!, docUploadType: self.isPassport ? .Passport: .LicenseFront, selfie: self.selfieImageData!)
            resultsTextView?.isHidden = true
            resultsLabel?.isHidden = false
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
        } else {
            uploadButton?.isHidden = true
        }
    }
    /*{
        if uplaodResult != nil {
            self.imgUpload.uploadSelfie(UploadCallback: self, docUploadResult: uplaodResult!, docUploadType: self.isPassport ? .Passport: .LicenseFront, selfie: self.selfieImageData!)
            resultsTextView?.isHidden = true
            resultsLabel?.isHidden = false
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
        } else {
        if let front = frontImageData,
            let selfie = selfieImageData {
            if isPassport {
                //imgUpload.uploadPassport(UploadCallback: self, front: front)
                imgUpload.uploadPassport(UploadCallback: self, front: front, selfie: selfie)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            } else if let back = backImageData {
                //imgUpload.uploadLicense(UploadCallback: self, front: front)
                //imgUpload.uploadLicense(UploadCallback: self, front: front, back: back)
                imgUpload.uploadLicense(UploadCallback: self, front: front, back: back, selfie: selfie)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            }
        }
        }
    }*/
    
    @IBAction func withSelfie(_ sender: UIButton) {
        if let front = frontImageData,
           let selfie = selfieImageData {
            isWithSeflie = true
            if isPassport {
                imgUpload.uploadPassport(UploadCallback: self, front: front, selfie: selfie)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            } else if let back = backImageData {
                imgUpload.uploadLicense(UploadCallback: self, front: front, back: back, selfie: selfie)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            }
        }
    }
    
    @IBAction func withOutSelfie(_ sender: Any) {
        if let front = frontImageData {
            if isPassport {
                imgUpload.uploadPassport(UploadCallback: self, front: front)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            } else if let back = backImageData {
                //imgUpload.uploadLicense(UploadCallback: self, front: front)
                imgUpload.uploadLicense(UploadCallback: self, front: front, back: back)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            } else {
                imgUpload.uploadLicense(UploadCallback: self, front: front)
                resultsLabel?.isHidden = false
                activityIndicator?.isHidden = false
                activityIndicator?.startAnimating()
            }
        }
    }
    
    
    @IBAction func closePressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UploadViewController: UploadCallback {
    
    func documentUploadFinished(uploadResult: UploadResult) {
        if uplaodResult == nil {
            resultsTextView?.text = "UUID is: " + (uploadResult.uuid ?? "") + "\n"
            resultsTextView?.isHidden = false
            activityIndicator?.isHidden = true
            activityIndicator?.stopAnimating()
            if !isWithSeflie && selfieImageData != nil {
                uplaodResult = uploadResult
                uploadButton?.isHidden = false
            }
        } else {
            uplaodResult = nil
            uploadButton?.isHidden = true
            resultsTextView?.text = "Upload done UUID is: " + (uploadResult.uuid ?? "") + "\n"
            resultsTextView?.isHidden = false
            activityIndicator?.isHidden = true
            activityIndicator?.stopAnimating()
        }
    }
    
    func onUploadError(errorType: SocureSDKErrorType, errorMessage: String) {
        DispatchQueue.main.async {
            self.resultsTextView?.text = "Upload failed with error: " + errorMessage
            self.resultsTextView?.isHidden = false
            self.activityIndicator?.isHidden = true
            self.activityIndicator?.stopAnimating()
        }
    }
    
}
