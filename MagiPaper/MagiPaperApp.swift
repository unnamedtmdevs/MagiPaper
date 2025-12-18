//
//  MagiPaperApp.swift
//  MagiPaper
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

@main
struct MagiPaperApp: App {
    @StateObject private var preferences = UserPreferences()
    @StateObject private var contentService = ContentService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(preferences)
                .environmentObject(contentService)
                .preferredColorScheme(.dark)
        }
    }
}
