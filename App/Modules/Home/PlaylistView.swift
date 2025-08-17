//
//  PlaylistView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

// MARK: - Playlist View
struct PlaylistView: View {
    let playlist: Playlist
    
    var body: some View {
        List(playlist.videos) { video in
            VideoListItemView(video: video) {
                // Handle video selection
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        .navigationTitle(playlist.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        PlaylistView(playlist: MockData.samplePlaylist)
    }
    .environmentObject(VideoManager())
}

// MARK: - Mock Data
private enum MockData {
    static let samplePlaylist = Playlist(
        id: "1",
        name: "Sample Playlist",
        description: "A collection of sample videos for testing",
        videos: [
            Video(
                id: "1",
                title: "Sample Video 1",
                description: "This is a sample video description",
                thumbnailURL: "https://picsum.photos/300/200?random=1",
                duration: "5:30",
                channel: "Sample Channel",
                viewCount: "1.2K views",
                publishedAt: "2 days ago"
            ),
            Video(
                id: "2",
                title: "Sample Video 2",
                description: "Another sample video description",
                thumbnailURL: "https://picsum.photos/300/200?random=2",
                duration: "8:15",
                channel: "Sample Channel",
                viewCount: "856 views",
                publishedAt: "1 week ago"
            )
        ],
        thumbnailURL: "https://picsum.photos/300/200?random=10",
        createdAt: Date()
    )
}
