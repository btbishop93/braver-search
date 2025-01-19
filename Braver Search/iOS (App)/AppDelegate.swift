//
//  AppDelegate.swift
//  Braver Search
//
//  Created by Brenden Bishop on 1/19/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize user defaults if needed
        let userDefaults = UserDefaults(suiteName: "group.xyz.bsquared.braversearch")
        if userDefaults?.bool(forKey: "enabled") == nil {
            userDefaults?.set(true, forKey: "enabled")
            userDefaults?.set("https://search.brave.com/search?q=", forKey: "searchUrl")
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
