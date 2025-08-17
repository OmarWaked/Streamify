//
//  VideoModel.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

// MARK: - Video Models
struct Video: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: String
    let duration: String?
    let channel: String?
    let viewCount: String?
    let publishedAt: String?
    let videoURL: String?
    
    init(id: String, title: String, description: String, thumbnailURL: String, duration: String? = nil, channel: String? = nil, viewCount: String? = nil, publishedAt: String? = nil, videoURL: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.duration = duration
        self.channel = channel
        self.viewCount = viewCount
        self.publishedAt = publishedAt
        self.videoURL = videoURL
    }
}

struct Playlist: Identifiable, Codable {
    let id: UUID
    var name: String
    var videos: [Video]
    var isPublic: Bool
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, videos: [Video] = [], isPublic: Bool = true, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.videos = videos
        self.isPublic = isPublic
        self.createdAt = createdAt
    }
}

// MARK: - Video Player View
struct VideoPlayerView: View {
    let video: Video
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var showControls = true
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
                    .onTapGesture {
                        withAnimation {
                            showControls.toggle()
                        }
                    }
                
                if showControls {
                    VStack {
                        Spacer()
                        VideoControlsView(
                            player: player,
                            isPlaying: $isPlaying,
                            currentTime: $currentTime,
                            duration: $duration
                        )
                        .background(Color.black.opacity(0.3))
                    }
                }
            } else {
                VideoPlaceholderView(video: video)
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    private func setupPlayer() {
        // For demo purposes, we'll use a sample video URL
        // In production, you'd extract the actual video URL from the video object
        let sampleURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        player = AVPlayer(url: sampleURL)
        
        // Add time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            currentTime = time.seconds
        }
        
        // Get duration
        player?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            DispatchQueue.main.async {
                if let duration = self.player?.currentItem?.asset.duration {
                    self.duration = CMTimeGetSeconds(duration)
                }
            }
        }
    }
}

// MARK: - Video Controls
struct VideoControlsView: View {
    let player: AVPlayer
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var duration: Double
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress bar
            ProgressView(value: currentTime, total: duration)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .padding(.horizontal)
            
            HStack {
                // Play/Pause button
                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                // Time labels
                Text(formatTime(currentTime))
                    .foregroundColor(.white)
                    .font(.caption)
                
                Spacer()
                
                Text(formatTime(duration))
                    .foregroundColor(.white)
                    .font(.caption)
                
                // Fullscreen button
                Button(action: toggleFullscreen) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
    
    private func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    private func toggleFullscreen() {
        // Implement fullscreen functionality
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Video Placeholder
struct VideoPlaceholderView: View {
    let video: Video
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    )
            }
            .frame(height: 200)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(video.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let channel = video.channel {
                    Text(channel)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let viewCount = video.viewCount {
                    Text(viewCount)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

// MARK: - Video List Item
struct VideoListItemView: View {
    let video: Video
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Thumbnail
                ZStack {
                    AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 120, height: 72)
                    .clipped()
                    .cornerRadius(10)
                    
                    // Play button overlay
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
                
                // Video info
                VStack(alignment: .leading, spacing: 8) {
                    Text(video.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let channel = video.channel {
                        Text(channel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    // Video metadata
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
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .fontWeight(.medium)
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

// MARK: - Video Grid Item
struct VideoGridItemView: View {
    let video: Video
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Thumbnail with play button overlay
                ZStack {
                    AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
                    
                    // Play button overlay
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
                
                // Video info
                VStack(alignment: .leading, spacing: 8) {
                    Text(video.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let channel = video.channel {
                        Text(channel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    // Video metadata
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
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Video Manager
class VideoManager: ObservableObject {
    @Published var currentVideo: Video?
    @Published var isPlaying = false
    @Published var currentPlaylist: Playlist?
    @Published var recentlyPlayed: [Video] = []
    @Published var favorites: [Video] = []
    
    func playVideo(_ video: Video) {
        currentVideo = video
        isPlaying = true
        
        // Add to recently played
        if !recentlyPlayed.contains(where: { $0.id == video.id }) {
            recentlyPlayed.insert(video, at: 0)
            if recentlyPlayed.count > 50 {
                recentlyPlayed = Array(recentlyPlayed.prefix(50))
            }
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
        favorites.contains(where: { $0.id == video.id })
    }
}
