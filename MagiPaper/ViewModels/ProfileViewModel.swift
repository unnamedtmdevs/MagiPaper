//
//  ProfileViewModel.swift
//  MagiPaper
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var selectedCategories: Set<Article.Category> = []
    @Published var preferredReadingTime: UserPreferences.ReadingTime = .anytime
    @Published var favoriteArticles: [Article] = []
    @Published var showResetAlert: Bool = false
    
    private let contentService: ContentService
    private let preferences: UserPreferences
    private var cancellables = Set<AnyCancellable>()
    
    init(contentService: ContentService, preferences: UserPreferences) {
        self.contentService = contentService
        self.preferences = preferences
        
        loadPreferences()
        setupBindings()
    }
    
    private func loadPreferences() {
        userName = preferences.userName
        selectedCategories = preferences.selectedCategories
        preferredReadingTime = preferences.preferredReadingTime
        updateFavoriteArticles()
    }
    
    private func setupBindings() {
        preferences.$favoriteArticles
            .sink { [weak self] _ in
                self?.updateFavoriteArticles()
            }
            .store(in: &cancellables)
    }
    
    func savePreferences() {
        preferences.userName = userName
        preferences.selectedCategories = selectedCategories
        preferences.preferredReadingTime = preferredReadingTime
    }
    
    func toggleCategory(_ category: Article.Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        savePreferences()
    }
    
    func updateReadingTime(_ time: UserPreferences.ReadingTime) {
        preferredReadingTime = time
        savePreferences()
    }
    
    func updateFavoriteArticles() {
        favoriteArticles = contentService.getFavoriteArticles(favoriteIds: preferences.favoriteArticles)
    }
    
    func removeFavorite(_ article: Article) {
        preferences.toggleFavorite(article.id)
    }
    
    func requestResetPreferences() {
        showResetAlert = true
    }
    
    func resetPreferences() {
        preferences.resetPreferences()
        loadPreferences()
    }
    
    var totalReadingTime: Int {
        favoriteArticles.reduce(0) { $0 + $1.readingTime }
    }
    
    var favoriteCount: Int {
        favoriteArticles.count
    }
    
    var categoryStats: [(category: Article.Category, count: Int)] {
        let grouped = Dictionary(grouping: favoriteArticles) { $0.category }
        return grouped.map { (category: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
}


