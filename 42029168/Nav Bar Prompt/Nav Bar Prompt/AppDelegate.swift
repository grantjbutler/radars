//
//  AppDelegate.swift
//  Nav Bar Prompt
//
//  Created by Grant Butler on 7/10/18.
//  Copyright © 2018 Lickability. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent = false
        navBarAppearance.tintColor = .white
        navBarAppearance.barTintColor = UIColor(red: 0.3922, green: 0.4157, blue: 0.949, alpha: 1)
        navBarAppearance.barStyle = .black
        navBarAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 22, weight: .heavy),
        ]
        
        let viewController = MasterViewController()
        let navController = UINavigationController(rootViewController: viewController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}

