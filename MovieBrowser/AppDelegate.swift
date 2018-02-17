//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Jeet on 12/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        let bundledPath: String = URL(fileURLWithPath: (Bundle.main.resourcePath)!).appendingPathComponent("CustomPathImages").absoluteString
        SDImageCache.shared().addReadOnlyCachePath(bundledPath)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
 
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }


}

