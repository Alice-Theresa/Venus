//
//  ActivityIndicatorWindow.swift
//  Venus
//
//  Created by Theresa on 2017/11/17.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class ActivityIndicatorWindow: UIWindow {
    
    static var window: UIWindow?
    
    class func show() {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.windowLevel = UIWindowLevelStatusBar + 1
            window?.rootViewController = ActivityIndicatorViewController()
            window?.makeKeyAndVisible()
        }
    }
    
    class func hide() {
        window?.resignKey()
        window?.isHidden = true
        window = nil
    }
    
}
