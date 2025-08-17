//
//  OnboardView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct OnboardView: View {
    @State private var currentPage = 0
    @State private var showSignIn = false
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Welcome to Streamify",
            subtitle: "Your ultimate streaming companion",
            description: "Discover, stream, and enjoy millions of videos and music tracks in one beautiful app.",
            imageName: "play.circle.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Unlimited Content",
            subtitle: "Videos, Music & More",
            description: "From trending videos to your favorite music, access everything you love with just one tap.",
            imageName: "music.note.list",
            color: .purple
        ),
        OnboardingPage(
            title: "Smart Recommendations",
            subtitle: "Personalized for You",
            description: "Our AI learns your preferences to suggest content you'll actually love.",
            imageName: "brain.head.profile",
            color: .green
        ),
        OnboardingPage(
            title: "Offline & Online",
            subtitle: "Stream Anywhere",
            description: "Download your favorites for offline listening or stream seamlessly online.",
            imageName: "wifi",
            color: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                // Bottom section
                bottomSection
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
    }
}

// MARK: - Extension
private extension OnboardView {
    var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var bottomSection: some View {
        VStack(spacing: 20) {
            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
            }
            
            // Navigation buttons
            HStack(spacing: 16) {
                if currentPage > 0 {
                    Button("Previous") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Spacer()
                
                if currentPage < onboardingPages.count - 1 {
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Button("Get Started") {
                        showSignIn = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(.horizontal, 32)
            
            // Skip button
            if currentPage < onboardingPages.count - 1 {
                Button("Skip") {
                    showSignIn = true
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 20)
            }
        }
        .padding(.bottom, 50)
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let color: Color
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: page.imageName)
                .font(.system(size: 100))
                .foregroundColor(page.color)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 160, height: 160)
                )
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(page.color)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    OnboardView()
}
