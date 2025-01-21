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

struct Message: Decodable {
    let type: String
    let enabled: Bool?
}

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        NSLog("Braver Search: Begin request")
        
        let userDefaults = UserDefaults(suiteName: "group.xyz.bsquared.braversearch")!
        var currentEnabled = userDefaults.bool(forKey: "enabled")
        
        // Parse incoming message
        if let item = context.inputItems.first as? NSExtensionItem,
           let userInfo = item.userInfo,
           let json = userInfo[SFExtensionMessageKey] as? String {
            NSLog("Braver Search: Received message: %@", json)
            
            if let data = json.data(using: .utf8),
               let message = try? JSONDecoder().decode(Message.self, from: data) {
                NSLog("Braver Search: Message type: %@", message.type)
                
                switch message.type {
                case "setState":
                    if let newState = message.enabled {
                        NSLog("Braver Search: Setting new state: %@", String(describing: newState))
                        userDefaults.set(newState, forKey: "enabled")
                        userDefaults.synchronize()
                        currentEnabled = newState
                    }
                case "getState":
                    NSLog("Braver Search: Getting current state")
                default:
                    NSLog("Braver Search: Unknown message type")
                }
            }
        }
        
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
            }
        }
        #endif
        
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