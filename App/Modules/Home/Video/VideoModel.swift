//
//  VideoModel.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI
import AVKit
import AVFoundation

// MARK: - Video Manager
class VideoManager: ObservableObject {
    @Published var recentlyPlayed: [Video] = []
    @Published var favorites: [Video] = []
    @Published var currentPlaylist: Playlist?
    
    private var player: AVPlayer?
    
    init() {
        loadMockData()
    }
    
    func playVideo(_ video: Video) {
        addToRecentlyPlayed(video)
        
        // Create player with video URL
        if let url = URL(string: video.thumbnailURL) {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
        }
    }
    
    func toggleFavorite(_ video: Video) {
        if let index = favorites.firstIndex(where: { $0.id == video.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(video)
        }
    }
    
    func isFavorite(_ video: Video) -> Bool {
        favorites.contains { $0.id == video.id }
    }
    
    private func addToRecentlyPlayed(_ video: Video) {
        // Remove if already exists
        recentlyPlayed.removeAll { $0.id == video.id }
        
        // Add to beginning
        recentlyPlayed.insert(video, at: 0)
        
        // Keep only last 20 videos
        if recentlyPlayed.count > 20 {
            recentlyPlayed = Array(recentlyPlayed.prefix(20))
        }
    }
    
    private func loadMockData() {
        // Load mock data for development
        recentlyPlayed = MockData.recentlyPlayed
        favorites = MockData.favorites
        currentPlaylist = MockData.samplePlaylist
    }
}

// MARK: - Video Model
struct Video: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: String
    let duration: String?
    let channel: String?
    let viewCount: String?
    let publishedAt: String?
    
    // Computed properties
    var formattedDuration: String {
        duration ?? "Unknown"
    }
    
    var formattedViewCount: String {
        viewCount ?? "0 views"
    }
    
    var formattedPublishedDate: String {
        publishedAt ?? "Unknown date"
    }
    
    var channelName: String {
        channel ?? "Unknown Channel"
    }
}

// MARK: - Playlist Model
struct Playlist: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let videos: [Video]
    let thumbnailURL: String?
    let createdAt: Date
    
    var videoCount: Int {
        videos.count
    }
    
    var formattedVideoCount: String {
        "\(videoCount) video\(videoCount == 1 ? "" : "s")"
    }
}

// MARK: - Video Grid Item View
struct VideoGridItemView: View {
    let video: Video
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                thumbnailSection
                contentSection
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Video Grid Item Extensions
private extension VideoGridItemView {
    var thumbnailSection: some View {
        ZStack {
            AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                placeholderView
            }
            .frame(height: 120)
            .clipped()
            .cornerRadius(12)
            
            playButtonOverlay
        }
    }
    
    var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            )
    }
    
    var playButtonOverlay: some View {
        Circle()
            .fill(Color.black.opacity(0.6))
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: "play.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            )
            .opacity(0.8)
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleSection
            channelSection
            metadataSection
        }
        .padding(.horizontal, 4)
    }
    
    var titleSection: some View {
        Text(video.title)
            .font(.subheadline)
            .fontWeight(.medium)
            .lineLimit(2)
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
    }
    
    var channelSection: some View {
        Text(video.channelName)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
    
    var metadataSection: some View {
        HStack(spacing: 12) {
            if let viewCount = video.viewCount {
                Text(viewCount)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if let publishedAt = video.publishedAt {
                Text("•")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(publishedAt)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Video List Item View
struct VideoListItemView: View {
    let video: Video
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                thumbnailSection
                contentSection
                Spacer()
                chevronSection
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

// MARK: - Video List Item Extensions
private extension VideoListItemView {
    var thumbnailSection: some View {
        ZStack {
            AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                placeholderView
            }
            .frame(width: 120, height: 72)
            .clipped()
            .cornerRadius(10)
            
            playButtonOverlay
        }
    }
    
    var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            )
    }
    
    var playButtonOverlay: some View {
        Circle()
            .fill(Color.black.opacity(0.6))
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            )
            .opacity(0.8)
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleSection
            channelSection
            metadataSection
        }
    }
    
    var titleSection: some View {
        Text(video.title)
            .font(.subheadline)
            .fontWeight(.medium)
            .lineLimit(2)
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
    }
    
    var channelSection: some View {
        Text(video.channelName)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
    
    var metadataSection: some View {
        HStack(spacing: 12) {
            if let viewCount = video.viewCount {
                Text(viewCount)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if let publishedAt = video.publishedAt {
                Text("•")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(publishedAt)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if let duration = video.duration {
                Text("•")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(duration)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    var chevronSection: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(.secondary)
            .font(.caption)
            .fontWeight(.medium)
    }
}

// MARK: - Mock Data
private enum MockData {
    static let recentlyPlayed = [
        Video(
            id: "1",
            title: "Amazing Music Performance Live",
            description: "Incredible live performance that will blow your mind",
            thumbnailURL: "https://picsum.photos/300/200?random=1",
            duration: "4:32",
            channel: "Music Channel",
            viewCount: "2.1M views",
            publishedAt: "1 day ago"
        ),
        Video(
            id: "2",
            title: "Epic Gaming Tournament Highlights",
            description: "Best moments from the latest gaming tournament",
            thumbnailURL: "https://picsum.photos/300/200?random=2",
            duration: "15:45",
            channel: "Gaming Pro",
            viewCount: "1.8M views",
            publishedAt: "3 days ago"
        )
    ]
    
    static let favorites = [
        Video(
            id: "3",
            title: "Science Explained Simply",
            description: "Complex scientific concepts made easy to understand",
            thumbnailURL: "https://picsum.photos/300/200?random=3",
            duration: "12:18",
            channel: "Science Hub",
            viewCount: "3.2M views",
            publishedAt: "1 week ago"
        )
    ]
    
    static let samplePlaylist = Playlist(
        id: "1",
        name: "My Favorites",
        description: "A collection of my favorite videos",
        videos: recentlyPlayed + favorites,
        thumbnailURL: "https://picsum.photos/300/200?random=10",
        createdAt: Date()
    )
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        VideoGridItemView(video: MockData.recentlyPlayed[0]) {
            print("Grid item tapped")
        }
        
        VideoListItemView(video: MockData.recentlyPlayed[0]) {
            print("List item tapped")
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
