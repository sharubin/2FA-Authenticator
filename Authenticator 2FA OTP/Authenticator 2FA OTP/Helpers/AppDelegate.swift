//
//  AppDelegate.swift
//  Authenticator 2FA OTP
//
//  Created by Artsem Sharubin on 06.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationController
        
        return true
    }
}

