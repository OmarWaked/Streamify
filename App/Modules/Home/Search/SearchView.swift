//
//  SearchView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

// MARK: - Main Search View
struct SearchView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedCategory: SearchCategory?
    @State private var searchResults: [Video] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBarSection
                
                if !searchText.isEmpty {
                    categoryFiltersSection
                }
                
                contentSection
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Search View Extensions
private extension SearchView {
    var searchBarSection: some View {
        SearchBar(
            text: $searchText,
            isSearching: $isSearching,
            onSubmit: performSearch
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    var categoryFiltersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(SearchCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category,
                        action: { selectCategory(category) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
    
    var contentSection: some View {
        Group {
            if isSearching {
                loadingView
            } else if searchResults.isEmpty && searchText.isEmpty {
                HomeContent()
            } else if searchResults.isEmpty && !searchText.isEmpty {
                NoResultsView(searchText: searchText)
            } else {
                SearchResultsView(videos: searchResults)
            }
        }
    }
    
    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Searching...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Search View Actions
private extension SearchView {
    func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        // Simulate search delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            searchResults = generateMockResults(for: searchText, category: selectedCategory)
            isSearching = false
        }
    }
    
    func selectCategory(_ category: SearchCategory) {
        selectedCategory = selectedCategory == category ? nil : category
        performSearch()
    }
    
    func generateMockResults(for query: String, category: SearchCategory?) -> [Video] {
        let allVideos = MockData.allVideos
        
        return allVideos.filter { video in
            let matchesQuery = video.title.localizedCaseInsensitiveContains(query) ||
                             video.description.localizedCaseInsensitiveContains(query)
            
            let matchesCategory = category == nil || category == .all || 
                                (category == .music && (video.title.localizedCaseInsensitiveContains("music") || video.title.localizedCaseInsensitiveContains("pop"))) ||
                                (category == .gaming && (video.title.localizedCaseInsensitiveContains("gaming") || video.title.localizedCaseInsensitiveContains("game"))) ||
                                (category == .education && (video.title.localizedCaseInsensitiveContains("educational") || video.title.localizedCaseInsensitiveContains("math") || video.title.localizedCaseInsensitiveContains("science"))) ||
                                (category == .entertainment && (video.title.localizedCaseInsensitiveContains("comedy") || video.title.localizedCaseInsensitiveContains("entertainment"))) ||
                                (category == .news && video.title.localizedCaseInsensitiveContains("news"))
            
            return matchesQuery && matchesCategory
        }
    }
}

// MARK: - Search Bar Component
struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                searchIcon
                textField
                clearButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Search Bar Extensions
private extension SearchBar {
    var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.secondary)
            .font(.system(size: 16))
    }
    
    var textField: some View {
        TextField("Search videos, music, and more...", text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .font(.body)
            .onSubmit(onSubmit)
    }
    
    var clearButton: some View {
        Group {
            if !text.isEmpty {
                Button(action: clearText) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
            }
        }
    }
    
    func clearText() {
        text = ""
        isSearching = false
    }
}

// MARK: - Search Category Enum
enum SearchCategory: CaseIterable {
    case all, music, gaming, education, entertainment, news
    
    var title: String {
        switch self {
        case .all: return "All"
        case .music: return "Music"
        case .gaming: return "Gaming"
        case .education: return "Education"
        case .entertainment: return "Entertainment"
        case .news: return "News"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "magnifyingglass"
        case .music: return "music.note"
        case .gaming: return "gamecontroller"
        case .education: return "book"
        case .entertainment: return "tv"
        case .news: return "newspaper"
        }
    }
}

// MARK: - Category Chip Component
struct CategoryChip: View {
    let category: SearchCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(category.title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Home Content View
struct HomeContent: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                CategoryView(title: "Recently Played", videos: MockData.recentlyPlayed)
                CategoryView(title: "Recommended", videos: MockData.recommended)
                CategoryView(title: "Trending", videos: MockData.trending)
                
                Spacer(minLength: 80)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Category View Component
struct CategoryView: View {
    let title: String
    let videos: [Video]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            contentSection
        }
    }
}

// MARK: - Category View Extensions
private extension CategoryView {
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

// MARK: - Search Results View
struct SearchResultsView: View {
    let videos: [Video]
    
    var body: some View {
        List(videos) { video in
            VideoListItemView(video: video) {
                // Handle video selection
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemBackground))
    }
}

// MARK: - No Results View
struct NoResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Text("No results found")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Try searching for something else or check your spelling")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Mock Data
private enum MockData {
    static let allVideos = [
        Video(
            id: "1", 
            title: "Amazing Music Performance", 
            description: "Live performance of popular songs", 
            thumbnailURL: "https://picsum.photos/300/200?random=1",
            duration: "4:15",
            channel: "Music Live",
            viewCount: "2.1M views",
            publishedAt: "1 day ago"
        ),
        Video(
            id: "2", 
            title: "Gaming Highlights - Epic Wins", 
            description: "Best gaming moments and victories", 
            thumbnailURL: "https://picsum.photos/300/200?random=2",
            duration: "8:30",
            channel: "Gaming Pro",
            viewCount: "1.8M views",
            publishedAt: "3 days ago"
        ),
        Video(
            id: "3", 
            title: "Educational Science Facts", 
            description: "Interesting scientific discoveries explained", 
            thumbnailURL: "https://picsum.photos/300/200?random=3",
            duration: "12:45",
            channel: "Science Hub",
            viewCount: "3.2M views",
            publishedAt: "1 week ago"
        ),
        Video(
            id: "4", 
            title: "Comedy Skit - Daily Life", 
            description: "Funny moments from everyday situations", 
            thumbnailURL: "https://picsum.photos/300/200?random=4",
            duration: "6:20",
            channel: "Comedy Central",
            viewCount: "1.5M views",
            publishedAt: "2 days ago"
        ),
        Video(
            id: "5", 
            title: "Pop Music Hits 2024", 
            description: "Latest pop music releases", 
            thumbnailURL: "https://picsum.photos/300/200?random=5",
            duration: "3:45",
            channel: "Pop Hits",
            viewCount: "2.8M views",
            publishedAt: "4 days ago"
        ),
        Video(
            id: "6", 
            title: "Strategy Game Tutorial", 
            description: "Learn advanced gaming strategies", 
            thumbnailURL: "https://picsum.photos/300/200?random=6",
            duration: "15:30",
            channel: "Gaming Academy",
            viewCount: "1.9M views",
            publishedAt: "1 week ago"
        ),
        Video(
            id: "7", 
            title: "Math Made Simple", 
            description: "Complex math concepts explained", 
            thumbnailURL: "https://picsum.photos/300/200?random=7",
            duration: "18:15",
            channel: "Math Master",
            viewCount: "2.3M views",
            publishedAt: "5 days ago"
        ),
        Video(
            id: "8", 
            title: "Entertainment News", 
            description: "Latest entertainment updates", 
            thumbnailURL: "https://picsum.photos/300/200?random=8",
            duration: "7:45",
            channel: "Entertainment Daily",
            viewCount: "1.7M views",
            publishedAt: "3 days ago"
        )
    ]
    
    static let recentlyPlayed = [
        Video(
            id: "1", 
            title: "Amazing Music Performance", 
            description: "Live performance", 
            thumbnailURL: "https://picsum.photos/300/200?random=1",
            duration: "4:15",
            channel: "Music Live",
            viewCount: "2.1M views",
            publishedAt: "1 day ago"
        ),
        Video(
            id: "2", 
            title: "Gaming Highlights", 
            description: "Best moments", 
            thumbnailURL: "https://picsum.photos/300/200?random=2",
            duration: "8:30",
            channel: "Gaming Pro",
            viewCount: "1.8M views",
            publishedAt: "3 days ago"
        ),
        Video(
            id: "3", 
            title: "Science Explained", 
            description: "Complex concepts", 
            thumbnailURL: "https://picsum.photos/300/200?random=3",
            duration: "12:45",
            channel: "Science Hub",
            viewCount: "3.2M views",
            publishedAt: "1 week ago"
        )
    ]
    
    static let recommended = [
        Video(
            id: "4", 
            title: "Pop Hits 2024", 
            description: "Latest music", 
            thumbnailURL: "https://picsum.photos/300/200?random=4",
            duration: "3:45",
            channel: "Pop Hits",
            viewCount: "2.8M views",
            publishedAt: "4 days ago"
        ),
        Video(
            id: "5", 
            title: "Strategy Games", 
            description: "Top gameplay", 
            thumbnailURL: "https://picsum.photos/300/200?random=5",
            duration: "15:30",
            channel: "Gaming Academy",
            viewCount: "1.9M views",
            publishedAt: "1 week ago"
        ),
        Video(
            id: "6", 
            title: "Math Tutorials", 
            description: "Learn easily", 
            thumbnailURL: "https://picsum.photos/300/200?random=6",
            duration: "18:15",
            channel: "Math Master",
            viewCount: "2.3M views",
            publishedAt: "5 days ago"
        )
    ]
    
    static let trending = [
        Video(
            id: "7", 
            title: "Viral Dance", 
            description: "Trending dance", 
            thumbnailURL: "https://picsum.photos/300/200?random=7",
            duration: "2:30",
            channel: "Dance Central",
            viewCount: "4.2M views",
            publishedAt: "1 day ago"
        ),
        Video(
            id: "8", 
            title: "Esports Finals", 
            description: "Championship", 
            thumbnailURL: "https://picsum.photos/300/200?random=8",
            duration: "25:45",
            channel: "Esports Pro",
            viewCount: "3.8M views",
            publishedAt: "2 days ago"
        ),
        Video(
            id: "9", 
            title: "Space Discovery", 
            description: "New findings", 
            thumbnailURL: "https://picsum.photos/300/200?random=9",
            duration: "14:20",
            channel: "Space Science",
            viewCount: "2.9M views",
            publishedAt: "1 week ago"
        )
    ]
}

// MARK: - Preview
#Preview {
    SearchView()
        .environmentObject(SignInViewModel())
        .environmentObject(VideoManager())
}
