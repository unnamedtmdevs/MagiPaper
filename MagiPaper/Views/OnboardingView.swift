//
//  OnboardingView.swift
//  MagiPaper
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var preferences: UserPreferences
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: viewModel.progress)
                    .tint(Color("AccentRed"))
                    .padding(.horizontal)
                    .padding(.top)
                
                // Content
                TabView(selection: $viewModel.currentStep) {
                    WelcomeStep(userName: $viewModel.userName)
                        .tag(0)
                    
                    CategorySelectionStep(selectedCategories: $viewModel.selectedCategories)
                        .tag(1)
                    
                    ReadingTimeStep(selectedTime: $viewModel.selectedReadingTime)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation Buttons
                HStack(spacing: 16) {
                    if viewModel.currentStep > 0 {
                        Button(action: {
                            viewModel.previousStep()
                        }) {
                            Text("Back")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color("AccentYellow"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color("SecondaryBackground"))
                                .cornerRadius(12)
                        }
                    }
                    
                    Button(action: {
                        if viewModel.currentStep == viewModel.totalSteps - 1 {
                            viewModel.completeOnboarding(preferences: preferences)
                        } else {
                            viewModel.nextStep()
                        }
                    }) {
                        Text(viewModel.currentStep == viewModel.totalSteps - 1 ? "Get Started" : "Next")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canProceed ? Color("AccentRed") : Color.gray.opacity(0.5))
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.canProceed)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }
}

struct WelcomeStep: View {
    @Binding var userName: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("📰")
                .font(.system(size: 80))
            
            Text("Welcome to VoolMagi Paper")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Your personalized magazine and newspaper reading experience")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What's your name?")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                TextField("Enter your name", text: $userName)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("SecondaryBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.top, 32)
            
            Spacer()
        }
    }
}

struct CategorySelectionStep: View {
    @Binding var selectedCategories: Set<Article.Category>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Your Interests")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 40)
            
            Text("Select categories you'd like to read about")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Article.Category.allCases, id: \.self) { category in
                        CategoryCard(
                            category: category,
                            isSelected: selectedCategories.contains(category)
                        ) {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 16)
        }
    }
}

struct CategoryCard: View {
    let category: Article.Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : Color("AccentYellow"))
                
                Text(category.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(isSelected ? Color("AccentRed") : Color("SecondaryBackground"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color("AccentYellow") : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct ReadingTimeStep: View {
    @Binding var selectedTime: UserPreferences.ReadingTime
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("⏰")
                .font(.system(size: 60))
            
            Text("When Do You Read?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("We'll personalize your feed for the best reading experience")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(spacing: 12) {
                ForEach(UserPreferences.ReadingTime.allCases, id: \.self) { time in
                    TimeSelectionButton(
                        time: time,
                        isSelected: selectedTime == time
                    ) {
                        selectedTime = time
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)
            
            Spacer()
        }
    }
}

struct TimeSelectionButton: View {
    let time: UserPreferences.ReadingTime
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: time.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : Color("AccentYellow"))
                    .frame(width: 40)
                
                Text(time.displayName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("AccentYellow"))
                }
            }
            .padding()
            .background(isSelected ? Color("AccentRed") : Color("SecondaryBackground"))
            .cornerRadius(12)
        }
    }
}


