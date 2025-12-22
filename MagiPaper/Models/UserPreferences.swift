//
//  UserPreferences.swift
//  MagiPaper
//

import Foundation
import SwiftUI

class UserPreferences: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("selectedCategories") private var selectedCategoriesData: Data = Data()
    @AppStorage("preferredReadingTime") var preferredReadingTime: ReadingTime = .anytime
    @AppStorage("userName") var userName: String = ""
    
    @Published var selectedCategories: Set<Article.Category> = [] {
        didSet {
            saveCategories()
        }
    }
    
    @Published var favoriteArticles: Set<UUID> = [] {
        didSet {
            saveFavorites()
        }
    }
    
    enum ReadingTime: String, CaseIterable {
        case morning = "Morning"
        case afternoon = "Afternoon"
        case evening = "Evening"
        case anytime = "Anytime"
        
        var displayName: String {
            self.rawValue
        }
        
        var icon: String {
            switch self {
            case .morning: return "sunrise.fill"
            case .afternoon: return "sun.max.fill"
            case .evening: return "moon.stars.fill"
            case .anytime: return "clock.fill"
            }
        }
    }
    
    init() {
        loadCategories()
        loadFavorites()
    }
    
    private func saveCategories() {
        let categories = selectedCategories.map { $0.rawValue }
        if let encoded = try? JSONEncoder().encode(categories) {
            selectedCategoriesData = encoded
        }
    }
    
    private func loadCategories() {
        guard !selectedCategoriesData.isEmpty,
              let categories = try? JSONDecoder().decode([String].self, from: selectedCategoriesData) else {
            // Default categories
            selectedCategories = [.technology, .business, .science]
            return
        }
        selectedCategories = Set(categories.compactMap { Article.Category(rawValue: $0) })
    }
    
    private func saveFavorites() {
        let favorites = Array(favoriteArticles)
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favoriteArticles")
        }
    }
    
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "favoriteArticles"),
              let favorites = try? JSONDecoder().decode([UUID].self, from: data) else {
            return
        }
        favoriteArticles = Set(favorites)
    }
    
    func toggleFavorite(_ articleId: UUID) {
        if favoriteArticles.contains(articleId) {
            favoriteArticles.remove(articleId)
        } else {
            favoriteArticles.insert(articleId)
        }
    }
    
    func isFavorite(_ articleId: UUID) -> Bool {
        favoriteArticles.contains(articleId)
    }
    
    func resetPreferences() {
        hasCompletedOnboarding = false
        selectedCategories = []
        preferredReadingTime = .anytime
        userName = ""
        favoriteArticles = []
    }
}


