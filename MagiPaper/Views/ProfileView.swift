//
//  ProfileView.swift
//  MagiPaper
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject var preferences: UserPreferences
    
    init(contentService: ContentService, preferences: UserPreferences) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(
            contentService: contentService,
            preferences: preferences
        ))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        ProfileHeaderView(
                            userName: $viewModel.userName,
                            favoriteCount: viewModel.favoriteCount,
                            totalReadingTime: viewModel.totalReadingTime
                        )
                        
                        // Preferences Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Preferences")
                            
                            // Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                TextField("Your name", text: $viewModel.userName, onCommit: {
                                    viewModel.savePreferences()
                                })
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("SecondaryBackground"))
                                .cornerRadius(12)
                            }
                            
                            // Reading Time
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Preferred Reading Time")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                ForEach(UserPreferences.ReadingTime.allCases, id: \.self) { time in
                                    Button(action: {
                                        viewModel.updateReadingTime(time)
                                    }) {
                                        HStack {
                                            Image(systemName: time.icon)
                                                .font(.system(size: 20))
                                                .foregroundColor(Color("AccentYellow"))
                                                .frame(width: 30)
                                            
                                            Text(time.displayName)
                                                .font(.system(size: 17))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            if viewModel.preferredReadingTime == time {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(Color("AccentRed"))
                                            }
                                        }
                                        .padding()
                                        .background(Color("SecondaryBackground"))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Categories Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Interests")
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(Article.Category.allCases, id: \.self) { category in
                                    CategoryToggleCard(
                                        category: category,
                                        isSelected: viewModel.selectedCategories.contains(category)
                                    ) {
                                        viewModel.toggleCategory(category)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Favorites Section
                        if !viewModel.favoriteArticles.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeader(title: "Saved Articles (\(viewModel.favoriteCount))")
                                
                                ForEach(viewModel.favoriteArticles.prefix(5)) { article in
                                    NavigationLink(destination: DetailView(article: article)) {
                                        FavoriteArticleRow(article: article) {
                                            viewModel.removeFavorite(article)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                                if viewModel.favoriteArticles.count > 5 {
                                    Text("+ \(viewModel.favoriteArticles.count - 5) more")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Stats Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Statistics")
                            
                            HStack(spacing: 16) {
                                StatCard(
                                    icon: "heart.fill",
                                    value: "\(viewModel.favoriteCount)",
                                    label: "Favorites"
                                )
                                
                                StatCard(
                                    icon: "clock.fill",
                                    value: "\(viewModel.totalReadingTime)",
                                    label: "Min Saved"
                                )
                                
                                StatCard(
                                    icon: "square.grid.2x2",
                                    value: "\(viewModel.selectedCategories.count)",
                                    label: "Categories"
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Account Deletion Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Account")
                            
                            VStack(spacing: 12) {
                                // Reset Preferences Button
                                Button(action: {
                                    viewModel.requestResetPreferences()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.counterclockwise")
                                        Text("Reset All Preferences")
                                            .font(.system(size: 17, weight: .semibold))
                                        Spacer()
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("SecondaryBackground"))
                                    .cornerRadius(12)
                                }
                                
                                // Delete Account Data Button
                                Button(action: {
                                    viewModel.requestDeleteAccount()
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                        Text("Delete Account & All Data")
                                            .font(.system(size: 17, weight: .semibold))
                                        Spacer()
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("AccentRed"))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .alert("Reset Preferences", isPresented: $viewModel.showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    viewModel.resetPreferences()
                }
            } message: {
                Text("Are you sure you want to reset all preferences? This action cannot be undone.")
            }
            .alert("Delete Account", isPresented: $viewModel.showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete Account", role: .destructive) {
                    viewModel.deleteAccount()
                }
            } message: {
                Text("This will permanently delete your account and all associated data including:\n\n• Your profile and preferences\n• All saved articles\n• Reading history\n• All personalization settings\n\nThis action cannot be undone.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileHeaderView: View {
    @Binding var userName: String
    let favoriteCount: Int
    let totalReadingTime: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color("AccentRed"), Color("AccentYellow")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Text(userName.prefix(1).uppercased())
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                )
            
            Text(userName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(favoriteCount)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("AccentYellow"))
                    Text("Saved")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                VStack(spacing: 4) {
                    Text("\(totalReadingTime)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("AccentYellow"))
                    Text("Min Read")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding()
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.white)
    }
}

struct CategoryToggleCard: View {
    let category: Article.Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : Color("AccentYellow"))
                
                Text(category.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(isSelected ? Color("AccentRed") : Color("SecondaryBackground"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("AccentYellow") : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct FavoriteArticleRow: View {
    let article: Article
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: article.category.icon)
                        .font(.system(size: 10))
                    Text(article.category.displayName)
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(Color("AccentYellow"))
                
                Text(article.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text("\(article.readingTime) min read")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color("AccentRed"))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color("SecondaryBackground"))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color("AccentYellow"))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("SecondaryBackground"))
        .cornerRadius(12)
    }
}


