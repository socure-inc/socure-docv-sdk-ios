//
//  ModalViewController.swift
//  BareBonesDemo2
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
        /*Now user can set the key via the following method instead of plist, it will override the key set in the plist*/
        d​ocScanner​.setSocurePublicKey(publicKey: "replace_me")
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.d​ocScanner​.initiateLicenseScan(ImageCallback: self, BarcodeCallback: self)
    }
}
extension ModalViewController: ImageCallback  {
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
        referenceViewController?.isPassport = false
        referenceViewController?.backDocumentData = nil
        referenceViewController?.backImageView.image = nil
    }
    
    func documentBackCallBack(docScanResult: DocScanResult) {
        guard let imageData = docScanResult.imageData,
            let image = UIImage.init(data: imageData) else {
                return
        }
        print("documentBackCallBack")
        print(docScanResult.metaData)
        print(docScanResult.dataExtracted)
        print(docScanResult.captureType)

        referenceViewController?.backDocumentData = imageData
        referenceViewController?.backImageView.image = image
        
        if( referenceViewController?.backDocumentData != nil &&
            referenceViewController?.frontDocumentData != nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func selfieCallBack(selfieScanResult: SelfieScanResult) {
        print("documentBackCallBack")
        print(selfieScanResult.metaData)
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
extension ModalViewController: BarcodeCallback {
    func handleBarcodeData(barcodeData: BarcodeData?) {
        guard let barcodeData = barcodeData else {
            print("Barcode data not found")
            return
        }
            
        print("Barcode data is \(barcodeData)")
        
    }
}
