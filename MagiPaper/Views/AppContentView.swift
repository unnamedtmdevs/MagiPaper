//
//  AppContentView.swift
//  MagiPaper
//

import SwiftUI

struct AppContentView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var contentService: ContentService
    
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case profile
    }
    
    var body: some View {
        if !preferences.hasCompletedOnboarding {
            OnboardingView()
                .environmentObject(preferences)
        } else {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Main Content
                    Group {
                        switch selectedTab {
                        case .home:
                            HomeView(
                                contentService: contentService,
                                preferences: preferences
                            )
                        case .profile:
                            ProfileView(
                                contentService: contentService,
                                preferences: preferences
                            )
                        }
                    }
                    
                    // Custom Tab Bar
                    HStack {
                        TabBarButton(
                            icon: "house.fill",
                            title: "Home",
                            isSelected: selectedTab == .home
                        ) {
                            selectedTab = .home
                        }
                        
                        TabBarButton(
                            icon: "person.fill",
                            title: "Profile",
                            isSelected: selectedTab == .profile
                        ) {
                            selectedTab = .profile
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .background(Color("SecondaryBackground"))
                }
            }
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(isSelected ? Color("AccentRed") : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    AppContentView()
        .environmentObject(UserPreferences())
        .environmentObject(ContentService())
}

