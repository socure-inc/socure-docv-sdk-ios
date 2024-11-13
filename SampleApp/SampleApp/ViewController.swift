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
        let options = SocureDocVOptions(publicKey: "REPLACE_KEY_HERE",
                                        docVTransactionToken: "REPLACE_TOKEN_HERE",
                                        presentingViewController: self,
                                        useSocureGov: false)

        SocureDocVSDK.launch(options) { [weak self] result in
            switch result {
            case .success(let successResult):
                self?.updateStatus("Upload Success: \(successResult)")
                print(successResult)
            case .failure(let failureResult):
                self?.updateStatus("Upload Failure: \(failureResult.error)")
                print(failureResult)
            }
        }

    }
}
