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
    @StateObject private var videoManager = VideoManager()
    
    var body: some View {
        VStack {
            viewDelegate
        }
        .onChange(of: signInViewModel.isSignedIn) {_, newValue in
            print("ContentView: isSignedIn changed to \(newValue)")
        }
        .environmentObject(videoManager)
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
    
    var onboard: some View {
        OnboardView()
            .environmentObject(signInViewModel)
    }
}

// MARK: - Library View
struct LibraryView: View {
    @EnvironmentObject var videoManager: VideoManager
    
    var body: some View {
        NavigationView {
            List {
                Section("Recently Played") {
                    if videoManager.recentlyPlayed.isEmpty {
                        Text("No recently played videos")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(videoManager.recentlyPlayed.prefix(10)) { video in
                            VideoListItemView(video: video) {
                                videoManager.playVideo(video)
                            }
                        }
                    }
                }
                
                Section("Favorites") {
                    if videoManager.favorites.isEmpty {
                        Text("No favorite videos")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(videoManager.favorites) { video in
                            VideoListItemView(video: video) {
                                videoManager.playVideo(video)
                            }
                        }
                    }
                }
                
                Section("Playlists") {
                    if let currentPlaylist = videoManager.currentPlaylist {
                        NavigationLink(destination: PlaylistDetailView(playlist: currentPlaylist)) {
                            HStack {
                                Image(systemName: "play.square.stack")
                                    .foregroundColor(.blue)
                                Text(currentPlaylist.name)
                                Spacer()
                                Text("\(currentPlaylist.videos.count) videos")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    } else {
                        Text("No playlists")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
            }
            .navigationTitle("Library")
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

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(SignInViewModel())
}
