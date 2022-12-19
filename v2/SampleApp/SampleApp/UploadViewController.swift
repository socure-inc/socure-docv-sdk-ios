//
//  UploadViewController.swift
// SampleApp
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
    
    @IBOutlet weak var uploadButton:UIButton?
    @IBOutlet weak var resultsTextView:UITextView?
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView?
    
    @IBOutlet weak var closeButton:UIButton?
    
    let imgUpload = ImageUploader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let front = frontImageData,
        let selfie = selfieImageData {
            if let back = backImageData {
                backImageView?.image = UIImage.init(data: back)
            }
            frontImageView?.image = UIImage.init(data: front)
            selfieImageView?.image = UIImage.init(data: selfie)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uploadButton?.isEnabled = true
    }
    
    @IBAction func uploadDocument(sender:UIButton) {
        
        if let front = frontImageData,
            let back = backImageData,
            let selfie = selfieImageData {
            
            imgUpload.uploadLicense(UploadCallback: self, front: front, back: back, selfie: selfie)
            resultsLabel?.isHidden = false
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
        } else if let front = frontImageData,
                  let selfie = selfieImageData {
                  
                  imgUpload.uploadPassport(UploadCallback: self, front: front, selfie: selfie)
                  resultsLabel?.isHidden = false
                  activityIndicator?.isHidden = false
                  activityIndicator?.startAnimating()
        }
    }
    
    @IBAction func closePressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UploadViewController: UploadCallback {
    
    func documentUploadFinished(uploadResult: UploadResult) {
        resultsTextView?.text = "UUID is: " + (uploadResult.uuid ?? "") + "\n"
        resultsTextView?.isHidden = false
        activityIndicator?.isHidden = true
        activityIndicator?.stopAnimating()
        print("uplaodUUID: \(uploadResult.uuid ?? "") sessionID: \(uploadResult.sessionId ?? "")")
    }
    
    func onUploadError(errorType: SocureSDKErrorType, errorMessage: String) {
        resultsTextView?.text = "Upload failed with error: " + errorMessage
        resultsTextView?.isHidden = false
        activityIndicator?.isHidden = true
        activityIndicator?.stopAnimating()

    }
    
}
