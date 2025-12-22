//
//  HomeViewModel.swift
//  MagiPaper
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var filteredArticles: [Article] = []
    @Published var selectedCategory: Article.Category?
    @Published var searchText: String = ""
    @Published var isRefreshing: Bool = false
    @Published var showFavoritesOnly: Bool = false
    
    private let contentService: ContentService
    private let preferences: UserPreferences
    private var cancellables = Set<AnyCancellable>()
    
    init(contentService: ContentService, preferences: UserPreferences) {
        self.contentService = contentService
        self.preferences = preferences
        
        setupBindings()
        loadArticles()
    }
    
    private func setupBindings() {
        // Listen to content service updates
        contentService.$articles
            .sink { [weak self] articles in
                self?.articles = articles
                self?.filterArticles()
            }
            .store(in: &cancellables)
        
        // Listen to search text changes
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterArticles()
            }
            .store(in: &cancellables)
        
        // Listen to category changes
        $selectedCategory
            .sink { [weak self] _ in
                self?.filterArticles()
            }
            .store(in: &cancellables)
        
        // Listen to favorites toggle
        $showFavoritesOnly
            .sink { [weak self] _ in
                self?.filterArticles()
            }
            .store(in: &cancellables)
        
        // Listen to user preferences changes
        preferences.$favoriteArticles
            .sink { [weak self] _ in
                self?.filterArticles()
            }
            .store(in: &cancellables)
    }
    
    func loadArticles() {
        let categories = preferences.selectedCategories
        
        if categories.isEmpty {
            filteredArticles = contentService.fetchArticles(for: Set(Article.Category.allCases))
        } else {
            filteredArticles = contentService.fetchArticles(for: categories)
        }
        
        filterArticles()
    }
    
    func filterArticles() {
        var result = articles
        
        // Filter by search text
        if !searchText.isEmpty {
            result = contentService.searchArticles(query: searchText)
        }
        
        // Filter by category
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        } else if !preferences.selectedCategories.isEmpty {
            // Show only user's preferred categories if no specific category selected
            result = result.filter { preferences.selectedCategories.contains($0.category) }
        }
        
        // Filter by favorites
        if showFavoritesOnly {
            result = result.filter { preferences.isFavorite($0.id) }
        }
        
        filteredArticles = result
    }
    
    func refreshContent() {
        isRefreshing = true
        contentService.refreshContent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isRefreshing = false
            self?.loadArticles()
        }
    }
    
    func toggleFavorite(_ article: Article) {
        preferences.toggleFavorite(article.id)
    }
    
    func isFavorite(_ article: Article) -> Bool {
        preferences.isFavorite(article.id)
    }
    
    func selectCategory(_ category: Article.Category?) {
        selectedCategory = category
    }
}


