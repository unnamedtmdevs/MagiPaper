//
//  HomeView.swift
//  MagiPaper
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject var preferences: UserPreferences
    
    init(contentService: ContentService, preferences: UserPreferences) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(
            contentService: contentService,
            preferences: preferences
        ))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HeaderView(
                        userName: preferences.userName,
                        searchText: $viewModel.searchText,
                        showFavoritesOnly: $viewModel.showFavoritesOnly
                    )
                    
                    // Category Filter
                    CategoryFilterView(
                        selectedCategory: $viewModel.selectedCategory,
                        categories: Array(preferences.selectedCategories)
                    )
                    
                    // Articles List
                    if viewModel.filteredArticles.isEmpty {
                        EmptyStateView(showFavoritesOnly: viewModel.showFavoritesOnly)
                    } else {
                        ArticleListView(
                            articles: viewModel.filteredArticles,
                            onFavorite: { article in
                                viewModel.toggleFavorite(article)
                            },
                            isFavorite: { article in
                                viewModel.isFavorite(article)
                            }
                        )
                        .refreshable {
                            viewModel.refreshContent()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HeaderView: View {
    let userName: String
    @Binding var searchText: String
    @Binding var showFavoritesOnly: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, \(userName)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Discover your stories")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: {
                    showFavoritesOnly.toggle()
                }) {
                    Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                        .font(.system(size: 22))
                        .foregroundColor(showFavoritesOnly ? Color("AccentRed") : .white)
                        .frame(width: 44, height: 44)
                        .background(Color("SecondaryBackground"))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.5))
                
                TextField("Search articles...", text: $searchText)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding()
            .background(Color("SecondaryBackground"))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: Article.Category?
    let categories: [Article.Category]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(categories.sorted(by: { $0.displayName < $1.displayName }), id: \.self) { category in
                    CategoryChip(
                        title: category.displayName,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color("AccentYellow"))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color("AccentRed") : Color("SecondaryBackground"))
            .cornerRadius(20)
        }
    }
}

struct ArticleListView: View {
    let articles: [Article]
    let onFavorite: (Article) -> Void
    let isFavorite: (Article) -> Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(articles) { article in
                    NavigationLink(destination: DetailView(article: article)) {
                        ArticleCard(
                            article: article,
                            isFavorite: isFavorite(article),
                            onFavorite: {
                                onFavorite(article)
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct ArticleCard: View {
    let article: Article
    let isFavorite: Bool
    let onFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    // Category Badge
                    HStack(spacing: 6) {
                        Image(systemName: article.category.icon)
                            .font(.system(size: 11))
                        Text(article.category.displayName)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(Color("AccentYellow"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("AccentYellow").opacity(0.2))
                    .cornerRadius(8)
                    
                    // Title
                    Text(article.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    // Summary
                    Text(article.summary)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                    
                    // Metadata
                    HStack(spacing: 16) {
                        Label(article.source, systemImage: "building.2")
                        Label("\(article.readingTime) min", systemImage: "clock")
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                // Favorite Button
                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(isFavorite ? Color("AccentRed") : .white.opacity(0.5))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color("SecondaryBackground"))
        .cornerRadius(16)
    }
}

struct EmptyStateView: View {
    let showFavoritesOnly: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: showFavoritesOnly ? "heart.slash" : "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text(showFavoritesOnly ? "No Favorites Yet" : "No Articles Found")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(showFavoritesOnly ?
                 "Start adding articles to your favorites" :
                 "Try adjusting your search or categories")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

