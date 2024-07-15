//
//  ContentView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct ContentView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    var body: some View {
        VStack {
            viewDelegate
        }
        .onChange(of: signInViewModel.isSignedIn) {_, newValue in
            print("ContentView: isSignedIn changed to \(newValue)")
        }
    }
}

// MARK: - Extension
private extension ContentView {
    var viewDelegate: some View {
        VStack {
            if signInViewModel.isSignedIn {
                content
            } else {
                onboard
            }
        }
    }
    
    var content: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            YouTubeSearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
    
    var onboard: some View {
        OnboardView()
            .environmentObject(signInViewModel)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
