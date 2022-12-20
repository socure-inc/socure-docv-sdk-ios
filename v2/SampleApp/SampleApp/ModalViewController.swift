//
//  ModalViewController.swift
// SampleApp
//
//  Created by Nicolas Dedual on 7/24/20.
//  Copyright © 2020 Socure Inc. All rights reserved.
//

import UIKit
import SocureSdk

class ModalViewController: UIViewController {

    var referenceViewController:ViewController?
    let d​ocScanner​ = DocumentScanner()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBlue
        // Do any additional setup after loading the view.
        self.d​ocScanner​.initiateLicenseScan(ImageCallback: self, BarcodeCallback: self)
    }

}
extension ModalViewController: ImageCallback  {
    func documentFrontCallBack(docScanResult: DocScanResult) {
        guard let imageData = docScanResult.imageData,
            let image = UIImage.init(data: imageData) else {
                return
        }
        print("documentFrontCallBack: CaptureType:\(docScanResult.captureType ?? -1) sessionId: \(docScanResult.sessionId ?? "") sessionToken: \(docScanResult.sessionToken ?? "")")
        referenceViewController?.frontDocumentData = imageData
        referenceViewController?.frontImageView.image = image
        
        if( referenceViewController?.backDocumentData != nil &&
                   referenceViewController?.frontDocumentData != nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func documentBackCallBack(docScanResult: DocScanResult) {
        guard let imageData = docScanResult.imageData,
            let image = UIImage.init(data: imageData) else {
                return
        }
        print("documentBackCallBack: CaptureType:\(docScanResult.captureType ?? -1) dataExtracted: \(docScanResult.dataExtracted ?? false) sessionId: \(docScanResult.sessionId ?? "") sessionToken: \(docScanResult.sessionToken ?? "")")
        referenceViewController?.backDocumentData = imageData
        referenceViewController?.backImageView.image = image
        
        if( referenceViewController?.backDocumentData != nil &&
            referenceViewController?.frontDocumentData != nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func selfieCallBack(selfieScanResult: SelfieScanResult) {
        
    }
    
    func onScanCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onError(errorType: SocureSDKErrorType, errorMessage: String) {
        print(errorType)
        print(errorMessage)
    }
    

}
extension ModalViewController: BarcodeCallback {
    func handleBarcodeData(barcodeData: BarcodeData?) {
        guard let barcodeData = barcodeData else {
            print("Barcode data not found")
            return
        }
            
        print("Barcode data is \(barcodeData)")
        
    }
}
