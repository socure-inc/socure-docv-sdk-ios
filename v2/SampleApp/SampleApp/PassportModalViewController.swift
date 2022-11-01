//
//  ModalViewController.swift
//  BareBonesDemo2
//
//  Created by Nicolas Dedual on 7/24/20.
//  Copyright © 2020 Socure Inc. All rights reserved.
//

import UIKit
import SocureSdk

class PassportModalViewController: UIViewController {

    var referenceViewController:ViewController?
    let d​ocScanner​ = DocumentScanner()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemGreen
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.d​ocScanner​.initiatePassportScan(ImageCallback: self, MRZCallback: self)
    }
}
extension PassportModalViewController: ImageCallback  {
    func documentFrontCallBack(docScanResult: DocScanResult) {
        guard let imageData = docScanResult.imageData,
            let image = UIImage.init(data: imageData) else {
                return
        }
        print("documentFrontCallBack")
        print(docScanResult.metaData)
        print(docScanResult.dataExtracted)
        print(docScanResult.captureType)

        referenceViewController?.frontDocumentData = imageData
        referenceViewController?.frontImageView.image = image
        if(referenceViewController?.frontDocumentData != nil) {
            referenceViewController?.backDocumentData = nil
            referenceViewController?.backImageView.image = nil
            referenceViewController?.isPassport = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func documentBackCallBack(docScanResult: DocScanResult) {
    }
    
    func selfieCallBack(selfieScanResult: SelfieScanResult) {
        
    }
    
    func onScanCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onError(errorType: SocureSDKErrorType, errorMessage: String) {
        print(errorType)
        print(errorMessage)
      //  self.dismiss(animated: true, completion: nil)
   }
    

}
extension PassportModalViewController: MRZCallback {
    func handleMRZData(mrzData: MrzData?) {
        guard let mrzData = mrzData else {
            print("MRZ data not found")
            return
        }
            
        print("MRZ data is \(mrzData)")
    }
}
