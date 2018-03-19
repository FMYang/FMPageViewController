//
//  AppDelegate.swift
//  PageViewController
//
//  Created by 杨方明 on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white

        let rootVC = ViewController()
        let nav = UINavigationController.init(rootViewController: rootVC)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
}

