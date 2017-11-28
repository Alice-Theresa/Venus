//
//  AppDelegate.swift
//  Venus
//
//  Created by S.C. on 2017/11/6.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ProjectSelectViewController())
        window?.makeKeyAndVisible()
        
        return true
    }

}

