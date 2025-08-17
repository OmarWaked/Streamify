//
//  ContentView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @StateObject private var videoManager = VideoManager()
    
    var body: some View {
        Group {
            if signInViewModel.isSignedIn {
                MainTabView()
            } else {
                OnboardView()
                    .environmentObject(signInViewModel)
            }
        }
        .environmentObject(videoManager)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "play.square.stack")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue)
    }
}

// MARK: - Library View
struct LibraryView: View {
    @EnvironmentObject var videoManager: VideoManager
    
    var body: some View {
        NavigationView {
            List {
                recentlyPlayedSection
                favoritesSection
                playlistsSection
            }
            .navigationTitle("Library")
        }
    }
}

// MARK: - Library View Extensions
private extension LibraryView {
    var recentlyPlayedSection: some View {
        Section("Recently Played") {
            if videoManager.recentlyPlayed.isEmpty {
                EmptyStateView(
                    icon: "play.square.stack",
                    title: "No Recently Played",
                    message: "Videos you watch will appear here"
                )
            } else {
                ForEach(videoManager.recentlyPlayed.prefix(10)) { video in
                    VideoListItemView(video: video) {
                        videoManager.playVideo(video)
                    }
                }
            }
        }
    }
    
    var favoritesSection: some View {
        Section("Favorites") {
            if videoManager.favorites.isEmpty {
                EmptyStateView(
                    icon: "heart",
                    title: "No Favorites",
                    message: "Tap the heart icon to save videos"
                )
            } else {
                ForEach(videoManager.favorites) { video in
                    VideoListItemView(video: video) {
                        videoManager.playVideo(video)
                    }
                }
            }
        }
    }
    
    var playlistsSection: some View {
        Section("Playlists") {
            if let currentPlaylist = videoManager.currentPlaylist {
                NavigationLink(destination: PlaylistDetailView(playlist: currentPlaylist)) {
                    PlaylistRowView(playlist: currentPlaylist)
                }
            } else {
                EmptyStateView(
                    icon: "play.square.stack.3d",
                    title: "No Playlists",
                    message: "Create playlists to organize your content"
                )
            }
        }
    }
}

// MARK: - Playlist Detail View
struct PlaylistDetailView: View {
    let playlist: Playlist
    
    var body: some View {
        List(playlist.videos) { video in
            VideoListItemView(video: video) {
                // Handle video selection
            }
        }
        .navigationTitle(playlist.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Playlist Row View
struct PlaylistRowView: View {
    let playlist: Playlist
    
    var body: some View {
        HStack {
            Image(systemName: "play.square.stack")
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(playlist.name)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("\(playlist.videos.count) videos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.secondary)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(SignInViewModel())
}
