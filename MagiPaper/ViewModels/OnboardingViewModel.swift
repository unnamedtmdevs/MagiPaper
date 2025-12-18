//
//  OnboardingViewModel.swift
//  MagiPaper
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var userName: String = ""
    @Published var selectedCategories: Set<Article.Category> = []
    @Published var selectedReadingTime: UserPreferences.ReadingTime = .anytime
    
    let totalSteps = 3
    
    var progress: Double {
        Double(currentStep) / Double(totalSteps)
    }
    
    var canProceed: Bool {
        switch currentStep {
        case 0:
            return !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 1:
            return !selectedCategories.isEmpty
        case 2:
            return true // Reading time always has a selection
        default:
            return true
        }
    }
    
    func nextStep() {
        if currentStep < totalSteps - 1 {
            withAnimation {
                currentStep += 1
            }
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation {
                currentStep -= 1
            }
        }
    }
    
    func toggleCategory(_ category: Article.Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    func completeOnboarding(preferences: UserPreferences) {
        preferences.userName = userName
        preferences.selectedCategories = selectedCategories
        preferences.preferredReadingTime = selectedReadingTime
        preferences.hasCompletedOnboarding = true
    }
}

