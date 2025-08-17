//
//  PlaylistView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

struct PlaylistView: View {
    var playlist: Playlist

    var body: some View {
        List(playlist.videos) { video in
            NavigationLink(destination: Text("Video Detail View - Coming Soon")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(video.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(video.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    if let channel = video.channel {
                        Text(channel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(playlist.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PlaylistView(playlist: Playlist(
            name: "Sample Playlist",
            videos: [
                Video(
                    id: "1",
                    title: "Sample Video 1",
                    description: "This is a sample video description",
                    thumbnailURL: "https://picsum.photos/300/200?random=1",
                    channel: "Sample Channel"
                ),
                Video(
                    id: "2",
                    title: "Sample Video 2",
                    description: "Another sample video description",
                    thumbnailURL: "https://picsum.photos/300/200?random=2",
                    channel: "Sample Channel"
                )
            ]
        ))
    }
    .environmentObject(VideoManager())
}
