//
//  SceneDelegate.swift
//  SampleApp
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let identifier = String(describing: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Make sure you set an Storyboard ID for the view controller you want to instantiate
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        window?.makeKeyAndVisible()
    }
}
