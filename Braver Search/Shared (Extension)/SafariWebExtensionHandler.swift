//
//  SafariWebExtensionHandler.swift
//  Braver Search Extension
//
//  Created by Brenden Bishop on 1/19/25.
//

import SafariServices
import os.log

struct Settings: Encodable {
    let enabled: Bool
    let searchUrl: String
}

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        NSLog("Braver Search: Begin request")
        
        let userDefaults = UserDefaults(suiteName: "group.xyz.bsquared.braversearch")!
        
        #if os(macOS)
        // On macOS, check Safari's extension state
        SFSafariExtensionManager.getStateOfSafariExtension(
            withIdentifier: "xyz.bsquared.braversearch.Braver-Search-Extension"
        ) { state, error in
            if let error = error {
                NSLog("Braver Search: Error getting extension state: %@", error.localizedDescription)
                return
            }
            
            if let state = state {
                NSLog("Braver Search: Extension enabled in Safari: %@", String(describing: state.isEnabled))
                userDefaults.set(state.isEnabled, forKey: "enabled")
                userDefaults.synchronize()
            }
        }
        #endif
        
        // Get current state (on iOS this is set by the app, on macOS by Safari)
        let currentEnabled = userDefaults.bool(forKey: "enabled")
        NSLog("Braver Search: Current enabled state: %@", String(describing: currentEnabled))
        
        let settings = Settings(
            enabled: currentEnabled,
            searchUrl: "https://search.brave.com/search?q="
        )
        
        sendResponse(settings, context: context)
    }
    
    private func sendResponse(_ settings: Settings, context: NSExtensionContext) {
        do {
            let data = try JSONEncoder().encode(settings)
            let json = String(data: data, encoding: .utf8)!
            NSLog("Braver Search: Sending settings JSON: %@", json)
            let extensionItem = NSExtensionItem()
            extensionItem.userInfo = [ SFExtensionMessageKey: json ]
            context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
        } catch {
            NSLog("Braver Search: Failed to encode settings: %@", error.localizedDescription)
            context.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
} 