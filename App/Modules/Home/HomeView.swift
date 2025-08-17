//
//  HomeView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

// MARK: - Main Home View
struct HomeView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @StateObject private var videoManager = VideoManager()
    @State private var selectedTab: HomeTab = .featured
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                tabSelectorSection
                tabContentSection
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .environmentObject(videoManager)
    }
}

// MARK: - Home View Extensions
private extension HomeView {
    var headerSection: some View {
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
                
                profileButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
        .padding(.bottom, 8)
    }
    
    var profileButton: some View {
        Button(action: handleProfileTap) {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
    
    var tabSelectorSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(HomeTab.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: { selectTab(tab) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
    }
    
    var tabContentSection: some View {
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

// MARK: - Home View Actions
private extension HomeView {
    func selectTab(_ tab: HomeTab) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedTab = tab
        }
    }
    
    func handleProfileTap() {
        // Handle profile button tap
    }
    
    func getGreeting(for userName: String?) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        let greeting: String
        switch hour {
        case 5..<12:
            greeting = "Good morning"
        case 12..<17:
            greeting = "Good afternoon"
        case 17..<22:
            greeting = "Good evening"
        default:
            greeting = "Good night"
        }
        
        if let name = userName, !name.isEmpty {
            return "\(greeting), \(name)"
        } else {
            return greeting
        }
    }
}

// MARK: - Home Tab Enum
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

// MARK: - Tab Button Component
struct TabButton: View {
    let tab: HomeTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(tab.title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Rectangle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(height: 2)
                    .frame(width: isSelected ? 20 : 0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Featured Tab View
struct FeaturedTabView: View {
    @State private var featuredVideos = MockData.featuredVideos
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if let heroVideo = featuredVideos.first {
                    HeroVideoView(video: heroVideo)
                        .padding(.top, 16)
                }
                
                CategorySection(title: "Trending Now", videos: featuredVideos)
                CategorySection(title: "Popular This Week", videos: featuredVideos)
                CategorySection(title: "Editor's Choice", videos: featuredVideos)
                
                Spacer(minLength: 80)
            }
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Music Tab View
struct MusicTabView: View {
    @State private var musicVideos = MockData.musicVideos
    
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

// MARK: - Gaming Tab View
struct GamingTabView: View {
    @State private var gamingVideos = MockData.gamingVideos
    
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

// MARK: - Education Tab View
struct EducationTabView: View {
    @State private var educationVideos = MockData.educationVideos
    
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
            thumbnailSection
            contentSection
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 20)
    }
}

// MARK: - Hero Video View Extensions
private extension HeroVideoView {
    var thumbnailSection: some View {
        ZStack {
            AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                placeholderView
            }
            .frame(height: 200)
            .clipped()
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            )
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(video.title)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            metadataSection
        }
        .padding(.horizontal, 20)
    }
    
    var metadataSection: some View {
        HStack(spacing: 16) {
            if let channel = video.channel {
                metadataItem(icon: "person.circle.fill", text: channel)
            }
            
            if let viewCount = video.viewCount {
                metadataItem(icon: "eye.fill", text: viewCount)
            }
            
            Spacer()
        }
    }
    
    func metadataItem(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Category Section
struct CategorySection: View {
    let title: String
    let videos: [Video]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            contentSection
        }
    }
}

// MARK: - Category Section Extensions
private extension CategorySection {
    var headerSection: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            seeAllButton
        }
        .padding(.horizontal, 20)
    }
    
    var seeAllButton: some View {
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
    
    var contentSection: some View {
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

// MARK: - Mock Data
private enum MockData {
    static let featuredVideos = [
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
    
    static let musicVideos = [
        Video(
            id: "4", 
            title: "Pop Hits 2024", 
            description: "Latest pop music hits", 
            thumbnailURL: "https://picsum.photos/300/200?random=4",
            duration: "3:45",
            channel: "Pop Music",
            viewCount: "1.5M views",
            publishedAt: "2 days ago"
        ),
        Video(
            id: "5", 
            title: "Rock Classics", 
            description: "Timeless rock music", 
            thumbnailURL: "https://picsum.photos/300/200?random=5",
            duration: "5:20",
            channel: "Rock Station",
            viewCount: "2.3M views",
            publishedAt: "1 week ago"
        ),
        Video(
            id: "6", 
            title: "Hip Hop Mix", 
            description: "Best hip hop tracks", 
            thumbnailURL: "https://picsum.photos/300/200?random=6",
            duration: "4:15",
            channel: "Hip Hop Central",
            viewCount: "1.8M views",
            publishedAt: "3 days ago"
        )
    ]
    
    static let gamingVideos = [
        Video(
            id: "7", 
            title: "FPS Highlights", 
            description: "Best FPS gaming moments", 
            thumbnailURL: "https://picsum.photos/300/200?random=7",
            duration: "8:30",
            channel: "Gaming Pro",
            viewCount: "2.7M views",
            publishedAt: "1 day ago"
        ),
        Video(
            id: "8", 
            title: "Strategy Games", 
            description: "Top strategy gameplay", 
            thumbnailURL: "https://picsum.photos/300/200?random=8",
            duration: "12:45",
            channel: "Strategy Master",
            viewCount: "1.9M views",
            publishedAt: "4 days ago"
        ),
        Video(
            id: "9", 
            title: "Esports News", 
            description: "Latest esports updates", 
            thumbnailURL: "https://picsum.photos/300/200?random=9",
            duration: "6:20",
            channel: "Esports Daily",
            viewCount: "3.1M views",
            publishedAt: "2 days ago"
        )
    ]
    
    static let educationVideos = [
        Video(
            id: "10", 
            title: "Math Tutorials", 
            description: "Learn math easily", 
            thumbnailURL: "https://picsum.photos/300/200?random=10",
            duration: "15:30",
            channel: "Math Academy",
            viewCount: "1.2M views",
            publishedAt: "1 week ago"
        ),
        Video(
            id: "11", 
            title: "History Lessons", 
            description: "Fascinating history facts", 
            thumbnailURL: "https://picsum.photos/300/200?random=11",
            duration: "18:45",
            channel: "History Channel",
            viewCount: "2.5M views",
            publishedAt: "5 days ago"
        ),
        Video(
            id: "12", 
            title: "Science Experiments", 
            description: "Fun science projects", 
            thumbnailURL: "https://picsum.photos/300/200?random=12",
            duration: "22:15",
            channel: "Science Lab",
            viewCount: "1.7M views",
            publishedAt: "3 days ago"
        )
    ]
}

// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(SignInViewModel())
}
