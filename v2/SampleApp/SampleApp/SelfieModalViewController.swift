//
//  SelfieModalViewController.swift
// SampleApp
//
//  Created by Nicolas Dedual on 8/7/20.
//  Copyright © 2020 Socure Inc. All rights reserved.
//

import UIKit
import SocureSdk

class SelfieModalViewController: UIViewController {

    var referenceViewController:ViewController?
    let selfieScanner = SelfieScanner()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemYellow
        // Do any additional setup after loading the view.
        
        self.selfieScanner.initiateSelfieScan(ImageCallback: self)
    }
}

extension SelfieModalViewController:ImageCallback {
    func documentFrontCallBack(docScanResult: DocScanResult) {

    }
    
    func documentBackCallBack(docScanResult: DocScanResult) {
    }
    
    func selfieCallBack(selfieScanResult: SelfieScanResult) {
        guard let imageData = selfieScanResult.imageData,
            let image = UIImage.init(data: imageData) else {
                return
        }
        referenceViewController?.selfieData = imageData
        referenceViewController?.selfieImageView.image = image

        if( referenceViewController?.selfieData != nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func onScanCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onError(errorType: SocureSDKErrorType, errorMessage: String) {
        print(errorType)
        print(errorMessage)
    }
    

}
