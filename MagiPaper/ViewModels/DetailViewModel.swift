//
//  DetailViewModel.swift
//  MagiPaper
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var article: Article
    @Published var relatedArticles: [Article] = []
    @Published var isFavorite: Bool = false
    @Published var showShareSheet: Bool = false
    
    private let contentService: ContentService
    private let preferences: UserPreferences
    private var cancellables = Set<AnyCancellable>()
    
    init(article: Article, contentService: ContentService, preferences: UserPreferences) {
        self.article = article
        self.contentService = contentService
        self.preferences = preferences
        self.isFavorite = preferences.isFavorite(article.id)
        
        loadRelatedArticles()
        setupBindings()
    }
    
    private func setupBindings() {
        preferences.$favoriteArticles
            .sink { [weak self] favorites in
                guard let self = self else { return }
                self.isFavorite = favorites.contains(self.article.id)
            }
            .store(in: &cancellables)
    }
    
    func loadRelatedArticles() {
        // Get articles from the same category, excluding current article
        let categoryArticles = contentService.getArticlesByCategory(article.category)
            .filter { $0.id != article.id }
        
        // Get articles with similar tags
        let taggedArticles = contentService.articles.filter { otherArticle in
            otherArticle.id != article.id &&
            !article.tags.filter { otherArticle.tags.contains($0) }.isEmpty
        }
        
        // Combine and remove duplicates
        var combined = categoryArticles + taggedArticles
        combined = Array(Set(combined))
        
        // Limit to 5 related articles
        relatedArticles = Array(combined.prefix(5))
    }
    
    func toggleFavorite() {
        preferences.toggleFavorite(article.id)
    }
    
    func share() {
        showShareSheet = true
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: article.publishedDate)
    }
    
    var estimatedReadingTimeText: String {
        if article.readingTime == 1 {
            return "1 min read"
        } else {
            return "\(article.readingTime) mins read"
        }
    }
}


