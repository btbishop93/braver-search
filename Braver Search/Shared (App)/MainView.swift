//
//  MainView.swift
//  Braver Search
//
//  Created by Brenden Bishop on 1/19/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("enabled", store: UserDefaults(suiteName: "group.xyz.bsquared.braversearch"))
    private var isEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Braver Search", isOn: $isEnabled)
                } header: {
                    Text("Settings")
                } footer: {
                    Text("When enabled, searches from Safari will be redirected to Brave Search")
                }
                
                Section {
                    Link("Open Safari Extensions Preferences", destination: URL(string: "safari-extensions://")!)
                        .foregroundColor(.blue)
                } header: {
                    Text("Safari Settings")
                } footer: {
                    Text("Make sure to enable Braver Search in Safari's extension settings")
                }
                
                Section {
                    Link("Visit Brave Search", destination: URL(string: "https://search.brave.com")!)
                        .foregroundColor(.orange)
                } footer: {
                    Text("Powered by Brave Search")
                }
            }
            .navigationTitle("Braver Search")
        }
    }
}

#Preview {
    MainView()
}