//
//  AppDelegate.swift
//  projectDemo
//
//  Created by Cheng on 2021/5/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let _ = GlobalManager(installed: true)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        
        return true
    }
}

