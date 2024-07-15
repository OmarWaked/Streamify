//
//  OnboardView.swift
//  Solis
//
//  Created by Rayan Waked on 7/12/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct OnboardView: View {
    var body: some View {
        ZStack {
            background
            headline
        }
    }
}

// MARK: - Extension
private extension OnboardView {
    // Background gradient or image, full screen, ignore safe area
    var background: some View {
        LinearGradient(colors: [.red, .indigo], startPoint: .bottomLeading, endPoint: .topTrailing)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
    
    // Header
    var headline: some View {
        VStack {
            Text("Welcome to Streamify")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.top, height/3)
            Spacer()
            SignInView()
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardView()
}
