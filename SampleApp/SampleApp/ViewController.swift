//
//  ViewController.swift
//  SdkWrapper
//
//  Created by Umamageshwaran Rajendran on 28/09/21.
//

import UIKit
import SocureDocV

class ViewController: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!

    let socureDocV = SocureDocVHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func updateStatus(_ status: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.lblStatus.text = status
        }
    }
    @IBAction func startScan(_ sender: Any) {
        socureDocV.launch("REPLACE_KEY_HERE", presentingViewController: self, config: nil) { [weak self]
            result in
            switch result {
            case .success(let scanInfo):
                self?.updateStatus("Upload Success: \(scanInfo.docUUID)")
                print(scanInfo)
            case .failure(let errorVal):
                self?.updateStatus(errorVal.errorMessage)
                print("Flow failed due to \(errorVal)")
            }
        }
    }
}
