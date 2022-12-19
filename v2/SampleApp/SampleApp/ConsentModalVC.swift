//
//  ConsentModalVC.swift
//  SDKWrapper
//
//  Created by Umamageshwaran Rajendran on 16/12/22.
//

import UIKit
import SocureSdk

class ConsentModalVC: UIViewController {

    var referenceViewController:ViewController?
    let consentVwObj = ConsentHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBlue
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        consentVwObj.showConsent(ConsentCallback: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ConsentModalVC: ConsentCallback {
    func consentResult(consentResult: ConsentResult) {
        print("Consent Success: \(consentResult.sessionId ?? "") \(consentResult.message ?? "")")
        self.dismiss(animated: true)
    }
    
    func onError(errorType: SocureSDKErrorType, errorMessage: String) {
        print(errorType)
        print(errorMessage)
    }
    
    func onScanCancelled() {
        self.dismiss(animated: true)
    }
    
}
