//
//  DetailView.swift
//  MagiPaper
//

import SwiftUI

struct DetailView: View {
    let article: Article
    @StateObject private var viewModel: DetailViewModel
    @EnvironmentObject var contentService: ContentService
    @EnvironmentObject var preferences: UserPreferences
    @Environment(\.dismiss) var dismiss
    
    init(article: Article) {
        self.article = article
        _viewModel = StateObject(wrappedValue: DetailViewModel(
            article: article,
            contentService: ContentService(),
            preferences: UserPreferences()
        ))
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Image
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color("AccentRed"), Color("SecondaryBackground")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 250)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            // Category Badge
                            HStack(spacing: 6) {
                                Image(systemName: article.category.icon)
                                    .font(.system(size: 12))
                                Text(article.category.displayName)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(8)
                        }
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        Text(article.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Metadata
                        HStack(spacing: 12) {
                            Label(article.author, systemImage: "person.fill")
                            Text("•")
                            Label(viewModel.formattedDate, systemImage: "calendar")
                            Text("•")
                            Label(viewModel.estimatedReadingTimeText, systemImage: "clock.fill")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        
                        // Source
                        Label(article.source, systemImage: "building.2")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("AccentYellow"))
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                        
                        // Summary
                        Text(article.summary)
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.vertical, 8)
                        
                        // Content
                        Text(article.content)
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(8)
                        
                        // Tags
                        if !article.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(article.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color("AccentYellow"))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color("AccentYellow").opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.vertical, 8)
                        
                        // Actions
                        HStack(spacing: 16) {
                            Button(action: {
                                viewModel.toggleFavorite()
                            }) {
                                HStack {
                                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                    Text(viewModel.isFavorite ? "Saved" : "Save")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(viewModel.isFavorite ? Color("AccentRed") : Color("SecondaryBackground"))
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                viewModel.share()
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color("SecondaryBackground"))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Related Articles
                        if !viewModel.relatedArticles.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Articles")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.top, 16)
                                
                                ForEach(viewModel.relatedArticles) { relatedArticle in
                                    NavigationLink(destination: DetailView(article: relatedArticle)) {
                                        RelatedArticleCard(article: relatedArticle)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? Color("AccentRed") : .white)
                }
            }
        }
    }
}

struct RelatedArticleCard: View {
    let article: Article
    
    var body: some View {
        HStack(spacing: 12) {
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
                
                HStack(spacing: 8) {
                    Text(article.author)
                    Text("•")
                    Text("\(article.readingTime) min")
                }
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding()
        .background(Color("SecondaryBackground"))
        .cornerRadius(12)
    }
}

