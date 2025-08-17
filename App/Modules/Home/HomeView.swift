//
//  HomeView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct HomeView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @StateObject private var videoManager = VideoManager()
    @State private var selectedTab: HomeTab = .featured
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                header
                
                // Tab selector
                tabSelector
                
                // Content
                tabContent
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .environmentObject(videoManager)
    }
}

// MARK: - Extension
private extension HomeView {
    var header: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(getGreeting(for: signInViewModel.userName))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Discover amazing content")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    // Profile action
                }) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
        .padding(.bottom, 8)
    }
    
    var tabSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(HomeTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(tab.title)
                                .font(.subheadline)
                                .fontWeight(selectedTab == tab ? .semibold : .medium)
                                .foregroundColor(selectedTab == tab ? .primary : .secondary)
                            
                            Rectangle()
                                .fill(selectedTab == tab ? Color.blue : Color.clear)
                                .frame(height: 2)
                                .frame(width: selectedTab == tab ? 20 : 0)
                                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
    }
    
    var tabContent: some View {
        TabView(selection: $selectedTab) {
            FeaturedTabView()
                .tag(HomeTab.featured)
            
            MusicTabView()
                .tag(HomeTab.music)
            
            GamingTabView()
                .tag(HomeTab.gaming)
            
            EducationTabView()
                .tag(HomeTab.education)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
    }
}

// MARK: - Home Tab
enum HomeTab: CaseIterable {
    case featured, music, gaming, education
    
    var title: String {
        switch self {
        case .featured: return "Featured"
        case .music: return "Music"
        case .gaming: return "Gaming"
        case .education: return "Education"
        }
    }
}

// MARK: - Featured Tab
struct FeaturedTabView: View {
    @State private var featuredVideos: [Video] = [
        Video(
            id: "1",
            title: "Amazing Music Performance Live",
            description: "Incredible live performance that will blow your mind",
            thumbnailURL: "https://picsum.photos/400/225?random=1",
            duration: "4:32",
            channel: "Music Channel",
            viewCount: "2.1M views",
            publishedAt: "1 day ago"
        ),
        Video(
            id: "2",
            title: "Epic Gaming Tournament Highlights",
            description: "Best moments from the latest gaming tournament",
            thumbnailURL: "https://picsum.photos/400/225?random=2",
            duration: "15:45",
            channel: "Gaming Pro",
            viewCount: "1.8M views",
            publishedAt: "3 days ago"
        ),
        Video(
            id: "3",
            title: "Science Explained Simply",
            description: "Complex scientific concepts made easy to understand",
            thumbnailURL: "https://picsum.photos/400/225?random=3",
            duration: "12:18",
            channel: "Science Hub",
            viewCount: "3.2M views",
            publishedAt: "1 week ago"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Hero section
                if let heroVideo = featuredVideos.first {
                    HeroVideoView(video: heroVideo)
                        .padding(.top, 16)
                }
                
                // Categories
                CategorySection(title: "Trending Now", videos: featuredVideos)
                CategorySection(title: "Popular This Week", videos: featuredVideos)
                CategorySection(title: "Editor's Choice", videos: featuredVideos)
                
                Spacer(minLength: 80)
            }
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Music Tab
struct MusicTabView: View {
    @State private var musicVideos: [Video] = [
        Video(id: "4", title: "Pop Hits 2024", description: "Latest pop music hits", thumbnailURL: "https://picsum.photos/300/200?random=4"),
        Video(id: "5", title: "Rock Classics", description: "Timeless rock music", thumbnailURL: "https://picsum.photos/300/200?random=5"),
        Video(id: "6", title: "Hip Hop Mix", description: "Best hip hop tracks", thumbnailURL: "https://picsum.photos/300/200?random=6")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                CategorySection(title: "Top Charts", videos: musicVideos)
                CategorySection(title: "New Releases", videos: musicVideos)
                CategorySection(title: "Playlists", videos: musicVideos)
                
                Spacer(minLength: 80)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Gaming Tab
struct GamingTabView: View {
    @State private var gamingVideos: [Video] = [
        Video(id: "7", title: "FPS Highlights", description: "Best FPS gaming moments", thumbnailURL: "https://picsum.photos/300/200?random=7"),
        Video(id: "8", title: "Strategy Games", description: "Top strategy gameplay", thumbnailURL: "https://picsum.photos/300/200?random=8"),
        Video(id: "9", title: "Esports News", description: "Latest esports updates", thumbnailURL: "https://picsum.photos/300/200?random=9")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                CategorySection(title: "Popular Games", videos: gamingVideos)
                CategorySection(title: "Live Streams", videos: gamingVideos)
                CategorySection(title: "Gaming News", videos: gamingVideos)
                
                Spacer(minLength: 80)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Education Tab
struct EducationTabView: View {
    @State private var educationVideos: [Video] = [
        Video(id: "10", title: "Math Tutorials", description: "Learn math easily", thumbnailURL: "https://picsum.photos/300/200?random=10"),
        Video(id: "11", title: "History Lessons", description: "Fascinating history facts", thumbnailURL: "https://picsum.photos/300/200?random=11"),
        Video(id: "12", title: "Science Experiments", description: "Fun science projects", thumbnailURL: "https://picsum.photos/300/200?random=12")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                CategorySection(title: "Academic Subjects", videos: educationVideos)
                CategorySection(title: "Skill Development", videos: educationVideos)
                CategorySection(title: "Documentaries", videos: educationVideos)
                
                Spacer(minLength: 80)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Hero Video View
struct HeroVideoView: View {
    let video: Video
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let url = URL(string: video.thumbnailURL) {
                AsyncImage(url: url) { image in
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
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    )
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(video.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                HStack(spacing: 16) {
                    if let channel = video.channel {
                        HStack(spacing: 6) {
                            Image(systemName: "person.circle.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(channel)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let viewCount = video.viewCount {
                        HStack(spacing: 6) {
                            Image(systemName: "eye.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewCount)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 20)
    }
}

// MARK: - Category Section
struct CategorySection: View {
    let title: String
    let videos: [Video]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("See All") {
                    // Navigate to category
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                )
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(videos) { video in
                        VideoGridItemView(video: video) {
                            // Handle video selection
                        }
                        .frame(width: 160)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(SignInViewModel())
}
