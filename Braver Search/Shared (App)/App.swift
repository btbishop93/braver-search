//
//  App.swift
//  Braver Search
//
//  Created by Brenden Bishop on 1/19/25.
//

import SwiftUI

struct BraverSearchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
} 