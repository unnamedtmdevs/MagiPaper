//
//  Strings.swift
//  MagiPaper
//

import Foundation

enum Strings {
    // MARK: - Onboarding
    enum Onboarding {
        static let welcome = "Welcome to VoolMagi Paper"
        static let welcomeSubtitle = "Your personalized magazine and newspaper reading experience"
        static let namePrompt = "What's your name?"
        static let namePlaceholder = "Enter your name"
        static let categoriesTitle = "Choose Your Interests"
        static let categoriesSubtitle = "Select categories you'd like to read about"
        static let readingTimeTitle = "When Do You Read?"
        static let readingTimeSubtitle = "We'll personalize your feed for the best reading experience"
        static let locationTitle = "Location-Based Content"
        static let locationSubtitle = "Get news and articles relevant to your location"
        static let enableLocation = "Enable Location Services"
        static let locationDisclaimer = "You can change this anytime in settings"
        static let next = "Next"
        static let back = "Back"
        static let getStarted = "Get Started"
    }
    
    // MARK: - Home
    enum Home {
        static let greeting = "Hello"
        static let subtitle = "Discover your stories"
        static let searchPlaceholder = "Search articles..."
        static let all = "All"
        static let noArticles = "No Articles Found"
        static let noArticlesMessage = "Try adjusting your search or categories"
        static let noFavorites = "No Favorites Yet"
        static let noFavoritesMessage = "Start adding articles to your favorites"
    }
    
    // MARK: - Detail
    enum Detail {
        static let readingTime = "min read"
        static let save = "Save"
        static let saved = "Saved"
        static let share = "Share"
        static let relatedArticles = "Related Articles"
    }
    
    // MARK: - Profile
    enum Profile {
        static let title = "Profile"
        static let preferences = "Preferences"
        static let name = "Name"
        static let namePlaceholder = "Your name"
        static let readingTime = "Preferred Reading Time"
        static let locationContent = "Location-Based Content"
        static let locationContentSubtitle = "Get articles relevant to your location"
        static let interests = "Interests"
        static let savedArticles = "Saved Articles"
        static let statistics = "Statistics"
        static let favorites = "Favorites"
        static let minutesSaved = "Min Saved"
        static let categories = "Categories"
        static let resetPreferences = "Reset All Preferences"
        static let resetTitle = "Reset Preferences"
        static let resetMessage = "Are you sure you want to reset all preferences? This action cannot be undone."
        static let cancel = "Cancel"
        static let reset = "Reset"
    }
    
    // MARK: - Categories
    enum Categories {
        static let technology = "Technology"
        static let business = "Business"
        static let science = "Science"
        static let entertainment = "Entertainment"
        static let sports = "Sports"
        static let health = "Health"
        static let politics = "Politics"
        static let travel = "Travel"
        static let lifestyle = "Lifestyle"
        static let culture = "Culture"
    }
    
    // MARK: - Common
    enum Common {
        static let ok = "OK"
        static let cancel = "Cancel"
        static let save = "Save"
        static let delete = "Delete"
        static let edit = "Edit"
        static let done = "Done"
    }
}

