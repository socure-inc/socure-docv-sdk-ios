//
//  ViewController.swift
// SampleApp
//
//  Created by Nicolas Dedual on 2/27/20.
//  Copyright © 2020 Socure Inc. All rights reserved.
//

import UIKit
import SocureSdk

class ViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var selfieCaptureButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var frontImageLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backImageLabel: UILabel!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var selfieImageLabel: UILabel!
    
    @IBOutlet weak var documentsLabel: UILabel!
    
    var frontDocumentData:Data?
    var backDocumentData:Data?
    var selfieData:Data?
    var isPassport = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if frontDocumentData != nil &&
            (backDocumentData != nil || isPassport) &&
            selfieData != nil {
            uploadButton.isEnabled = true
            uploadButton.backgroundColor = UIColor.systemRed
        } else {
            uploadButton.isEnabled = false
            uploadButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if frontDocumentData != nil &&
        (backDocumentData != nil || isPassport) &&
            selfieData != nil {
                uploadButton.isEnabled = true
                uploadButton.backgroundColor = UIColor.systemRed
            } else {
                uploadButton.isEnabled = false
                uploadButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        }
    }
        
    @IBAction func didCaptureButton(sender:UIButton) {
        
        DocumentScanner.requestCameraPermissions { (permissionsGranted) in
            DispatchQueue.main.async {
                
                if (permissionsGranted) {
                    self.isPassport = false
                    let viewController = ModalViewController()
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.referenceViewController = self
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title:
                                "Permission Error", message: "This application requires access to the camera to function. Please grant camera permission for the application", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    
                            }))
                            
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didCapturePassport(sender:UIButton) {
        
        DocumentScanner.requestCameraPermissions { (permissionsGranted) in
            DispatchQueue.main.async {
                
                if (permissionsGranted) {
                    self.isPassport = true
                    let viewController = PassportModalViewController()
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.referenceViewController = self
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title:
                                "Permission Error", message: "This application requires access to the camera to function. Please grant camera permission for the application", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    
                            }))
                            
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didCaptureSelfieButton(sender:UIButton) {
        
        SelfieScanner.requestCameraPermissions { (permissionsGranted) in
            DispatchQueue.main.async {
                
                if (permissionsGranted) {
                    
                    let viewController = SelfieModalViewController()
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.referenceViewController = self
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title:
                                "Permission Error", message: "This application requires access to the camera to function. Please grant camera permission for the application", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    
                            }))
                            
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didPressUploadButton(sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.frontImageData = frontDocumentData
            viewController.backImageData = backDocumentData
            viewController.selfieImageData = selfieData
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

