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
            NavigationLink(destination: YouTubePlayerView(videoID: video.id)) {
                VStack(alignment: .leading) {
                    Text(video.title)
                        .font(.headline)
                    Text(video.description)
                        .font(.subheadline)
                        .lineLimit(2)
                }
            }
        }
        .navigationTitle(playlist.name)
    }
}
