//
//  AppDelegate.swift
// SampleApp
//
//  Created by Nicolas Dedual on 2/27/20.
//  Copyright © 2020 Socure Inc. All rights reserved.
//

import UIKit
import SocureSdk

@UIApplicationMain
class AppDelegate: UIResponder {
  // MARK: - properties -
  var window: UIWindow?
  var imageclear : String = ""
  var isCameraModeEnabled = false

}

// MARK: - UIApplicationDelegates -
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SocureSDKConfigurator.shared.setPreferences()
    
        return true
  }
  /*  @objc private func deviceHasRotated() {
        
        UIDevice.current.setValue(Int(UIDevice.current.orientation.rawValue), forKey: "orientation")
    }
*/
  
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}


    
 /*   func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isCameraModeEnabled {
            // Unlock landscape view orientations for this view controller
            return .landscapeRight
        }
        
        // Only allow portrait (standard behaviour)
        return .portrait
    } */
}
