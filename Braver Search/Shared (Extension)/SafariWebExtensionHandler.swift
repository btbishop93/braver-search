//
//  SafariWebExtensionHandler.swift
//  Braver Search Extension
//
//  Created by Brenden Bishop on 1/19/25.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        struct Settings: Encodable {
            let enabled: Bool
            let searchUrl: String
        }
        
        let userDefaults = UserDefaults(suiteName: "group.xyz.bsquared.braversearch")!
        let isEnabled = userDefaults.bool(forKey: "enabled")
        
        os_log(.debug, "Braver Search: Reading settings - enabled: %{public}@", String(describing: isEnabled))
        
        let settings = Settings(
            enabled: isEnabled,
            searchUrl: "https://search.brave.com/search?q="
        )
        
        do {
            let data = try JSONEncoder().encode(settings)
            let json = String(data: data, encoding: .utf8)!
            let extensionItem = NSExtensionItem()
            extensionItem.userInfo = [ SFExtensionMessageKey: json ]
            context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
        } catch {
            os_log(.error, "Failed to encode settings: %{public}@", error.localizedDescription)
            context.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
} 