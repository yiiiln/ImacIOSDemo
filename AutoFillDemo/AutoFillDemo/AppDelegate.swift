//
//  AppDelegate.swift
//  AutoFillDemo
//
//  Created by 侯懿玲 on 2022/7/5.
//

import UIKit
import AutoFillTest

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    /// 10add
    // iOS 13 以下背景存活，用 12.4 的 Xs Max 模擬器測可以在背景存活１小時 (沒有關螢幕) by 秉翰寫的
    var bgTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 123)
    func applicationWillResignActive(_ application: UIApplication) {
        bgTaskID = UIApplication.shared.beginBackgroundTask() {
            print("bgTaskID = UIApplication.shared.beginBackgroundTask()")
        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.endBackgroundTask(bgTaskID)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("滑掉到背景")
    }
    ///  10add
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

