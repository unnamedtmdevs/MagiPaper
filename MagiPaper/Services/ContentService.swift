//
//  ContentService.swift
//  MagiPaper
//

import Foundation
import Combine

class ContentService: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadArticles()
    }
    
    func loadArticles() {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay for realistic feel
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.articles = Article.sampleArticles
            self?.isLoading = false
        }
    }
    
    func fetchArticles(for categories: Set<Article.Category>) -> [Article] {
        var filtered = articles
        
        // Filter by categories
        if !categories.isEmpty {
            filtered = filtered.filter { categories.contains($0.category) }
        }
        
        return filtered.sorted { $0.publishedDate > $1.publishedDate }
    }
    
    func searchArticles(query: String) -> [Article] {
        guard !query.isEmpty else { return articles }
        
        let lowercasedQuery = query.lowercased()
        return articles.filter { article in
            article.title.lowercased().contains(lowercasedQuery) ||
            article.summary.lowercased().contains(lowercasedQuery) ||
            article.author.lowercased().contains(lowercasedQuery) ||
            article.tags.contains(where: { $0.lowercased().contains(lowercasedQuery) })
        }
    }
    
    func getArticlesByCategory(_ category: Article.Category) -> [Article] {
        articles.filter { $0.category == category }
    }
    
    func getArticle(by id: UUID) -> Article? {
        articles.first { $0.id == id }
    }
    
    func getFavoriteArticles(favoriteIds: Set<UUID>) -> [Article] {
        articles.filter { favoriteIds.contains($0.id) }
    }
    
    func refreshContent() {
        loadArticles()
    }
}


