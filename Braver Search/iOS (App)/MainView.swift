//
//  MainView.swift
//  Braver Search
//
//  Created by Brenden Bishop on 1/19/25.
//

import SwiftUI
import os.log

struct MainView: View {
    @State private var isEnabled: Bool
    private let userDefaults: UserDefaults
    
    init() {
        let defaults = UserDefaults(suiteName: "group.xyz.bsquared.braversearch")!
        self.userDefaults = defaults
        
        // Initialize state from UserDefaults
        if defaults.object(forKey: "enabled") == nil {
            defaults.set(true, forKey: "enabled")
            defaults.synchronize()
            self._isEnabled = State(initialValue: true)
        } else {
            self._isEnabled = State(initialValue: defaults.bool(forKey: "enabled"))
        }
        
        os_log(.debug, "Braver Search: Initialized with enabled = %{public}@", String(describing: self._isEnabled.wrappedValue))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Braver Search", isOn: $isEnabled)
                        .onChange(of: isEnabled) { newValue in
                            os_log(.debug, "Braver Search: Toggle changed to %{public}@", String(describing: newValue))
                            userDefaults.set(newValue, forKey: "enabled")
                            userDefaults.synchronize()
                        }
                } header: {
                    Text("Settings")
                } footer: {
                    Text("When enabled, searches from Safari with Google, DuckDuckGo, or Bing will be redirected to Brave Search")
                }
                
                Section {
                    Link("Open Settings", destination: URL(string: "App-Prefs:root=SAFARI")!)
                        .foregroundColor(.blue)
                } header: {
                    Text("Safari Settings")
                } footer: {
                    Text("1. Scroll down and tap Apps\n2. Scroll down and tap Safari\n3. Scroll down and tap Extensions\n4. Enable Braver Search")
                }
                
                Section {
                    Link("Visit Brave Search", destination: URL(string: "https://search.brave.com")!)
                        .foregroundColor(.orange)
                } footer: {
                    Text("Powered by Brave Search")
                }

                Section {
                    Link(destination: URL(string: "https://buymeacoffee.com/brendenbishop")!) {
                        Image("BmcButton")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                    }
                } header: {
                    Text("Want to support me?")
                } footer: {
                    Text("Note: All donations are optional and not required to use the app.")
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Braver Search")
        }
    }
}

#Preview {
    MainView()
} 