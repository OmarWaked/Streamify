//
//  VideoDetailView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI
import AVKit

// MARK: - Video Detail View
struct VideoDetailView: View {
    let video: Video
    @EnvironmentObject var videoManager: VideoManager
    @Environment(\.dismiss) private var dismiss
    @State private var showVideoPlayer = false
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Video player section
                videoPlayerSection
                
                // Video info section
                videoInfoSection
                
                // Action buttons
                actionButtonsSection
                
                // Description
                descriptionSection
                
                // Related videos
                relatedVideosSection
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showVideoPlayer = true }) {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .fullScreenCover(isPresented: $showVideoPlayer) {
            VideoPlayerFullScreenView(video: video)
        }
        .onAppear {
            isFavorite = videoManager.isFavorite(video)
        }
    }
}

// MARK: - Extension
private extension VideoDetailView {
    var videoPlayerSection: some View {
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
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    )
            }
            .frame(height: 250)
            .clipped()
            
            // Play button overlay
            Button(action: { showVideoPlayer = true }) {
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )
            }
        }
    }
    
    var videoInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and channel
            VStack(alignment: .leading, spacing: 8) {
                Text(video.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(3)
                
                HStack {
                    if let channel = video.channel {
                        Text(channel)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let viewCount = video.viewCount {
                        Text(viewCount)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Metadata
            HStack(spacing: 16) {
                if let publishedAt = video.publishedAt {
                    Label(publishedAt, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let duration = video.duration {
                    Label(duration, systemImage: "timer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    var actionButtonsSection: some View {
        HStack(spacing: 20) {
            Button(action: toggleFavorite) {
                VStack(spacing: 4) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : .primary)
                    Text(isFavorite ? "Liked" : "Like")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: shareVideo) {
                VStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(.primary)
                    Text("Share")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: downloadVideo) {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                    Text("Download")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: addToPlaylist) {
                VStack(spacing: 4) {
                    Image(systemName: "plus.square.on.square")
                        .font(.title2)
                        .foregroundColor(.primary)
                    Text("Add to")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        
        Divider()
            .padding(.horizontal)
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(video.description)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(nil)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        
        Divider()
            .padding(.horizontal)
    }
    
    var relatedVideosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Related Videos")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        RelatedVideoCard(index: index)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 16)
    }
    
    func toggleFavorite() {
        videoManager.toggleFavorite(video)
        isFavorite.toggle()
    }
    
    func shareVideo() {
        // Implement share functionality
    }
    
    func downloadVideo() {
        // Implement download functionality
    }
    
    func addToPlaylist() {
        // Implement add to playlist functionality
    }
}

// MARK: - Related Video Card
struct RelatedVideoCard: View {
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "https://picsum.photos/200/120?random=\(index + 20)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 200, height: 120)
            .clipped()
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Related Video \(index + 1)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text("Channel Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 200)
    }
}

// MARK: - Video Player Full Screen View
struct VideoPlayerFullScreenView: View {
    let video: Video
    @Environment(\.dismiss) private var dismiss
    @StateObject private var videoManager = VideoManager()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Video player
                VideoPlayerView(video: video)
                    .aspectRatio(16/9, contentMode: .fit)
                
                // Close button
                HStack {
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            videoManager.playVideo(video)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        VideoDetailView(video: Video(
            id: "1",
            title: "Sample Video Title",
            description: "This is a sample video description that shows what the video is about.",
            thumbnailURL: "https://picsum.photos/400/225?random=1",
            duration: "4:32",
            channel: "Sample Channel",
            viewCount: "1.2M views",
            publishedAt: "2 days ago"
        ))
    }
    .environmentObject(VideoManager())
}
