//
//  ActivityIndicatorViewController.swift
//  Venus
//
//  Created by Theresa on 2017/11/17.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.center = view.center
        indicatorView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorView.startAnimating()
        indicatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = 10
        view.addSubview(indicatorView)
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }

}
