//
//  SearchView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct SearchView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedCategory: SearchCategory?
    @State private var searchResults: [Video] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                searchBar
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                // Category chips
                if !searchText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(SearchCategory.allCases, id: \.self) { category in
                                CategoryChip(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    action: {
                                        selectedCategory = selectedCategory == category ? nil : category
                                        performSearch()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
                
                // Content
                if isSearching {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchResults.isEmpty && searchText.isEmpty {
                    HomeContent()
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    NoResultsView(searchText: searchText)
                } else {
                    SearchResultsView(videos: searchResults)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16))
                
                TextField("Search videos, music, and more...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .onSubmit(performSearch)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                        selectedCategory = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private func performSearch() {
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
    
    private func generateMockResults(for query: String, category: SearchCategory?) -> [Video] {
        let allVideos = [
            Video(id: "1", title: "Amazing Music Performance", description: "Live performance of popular songs", thumbnailURL: "https://picsum.photos/300/200?random=1"),
            Video(id: "2", title: "Gaming Highlights - Epic Wins", description: "Best gaming moments and victories", thumbnailURL: "https://picsum.photos/300/200?random=2"),
            Video(id: "3", title: "Educational Science Facts", description: "Interesting scientific discoveries explained", thumbnailURL: "https://picsum.photos/300/200?random=3"),
            Video(id: "4", title: "Comedy Skit - Daily Life", description: "Funny moments from everyday situations", thumbnailURL: "https://picsum.photos/300/200?random=4"),
            Video(id: "5", title: "Pop Music Hits 2024", description: "Latest pop music releases", thumbnailURL: "https://picsum.photos/300/200?random=5"),
            Video(id: "6", title: "Strategy Game Tutorial", description: "Learn advanced gaming strategies", thumbnailURL: "https://picsum.photos/300/200?random=6"),
            Video(id: "7", title: "Math Made Simple", description: "Complex math concepts explained", thumbnailURL: "https://picsum.photos/300/200?random=7"),
            Video(id: "8", title: "Entertainment News", description: "Latest entertainment updates", thumbnailURL: "https://picsum.photos/300/200?random=8")
        ]
        
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

// MARK: - Search Category
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

// MARK: - Category Chip
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

// MARK: - Home Content
struct HomeContent: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                CategoryView(title: "Recently Played", videos: mockRecentlyPlayed)
                CategoryView(title: "Recommended", videos: mockRecommended)
                CategoryView(title: "Trending", videos: mockTrending)
                
                Spacer(minLength: 80)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemBackground))
    }
    
    private var mockRecentlyPlayed: [Video] {
        [
            Video(id: "1", title: "Amazing Music Performance", description: "Live performance", thumbnailURL: "https://picsum.photos/300/200?random=1"),
            Video(id: "2", title: "Gaming Highlights", description: "Best moments", thumbnailURL: "https://picsum.photos/300/200?random=2"),
            Video(id: "3", title: "Science Explained", description: "Complex concepts", thumbnailURL: "https://picsum.photos/300/200?random=3")
        ]
    }
    
    private var mockRecommended: [Video] {
        [
            Video(id: "4", title: "Pop Hits 2024", description: "Latest music", thumbnailURL: "https://picsum.photos/300/200?random=4"),
            Video(id: "5", title: "Strategy Games", description: "Top gameplay", thumbnailURL: "https://picsum.photos/300/200?random=5"),
            Video(id: "6", title: "Math Tutorials", description: "Learn easily", thumbnailURL: "https://picsum.photos/300/200?random=6")
        ]
    }
    
    private var mockTrending: [Video] {
        [
            Video(id: "7", title: "Viral Dance", description: "Trending dance", thumbnailURL: "https://picsum.photos/300/200?random=7"),
            Video(id: "8", title: "Esports Finals", description: "Championship", thumbnailURL: "https://picsum.photos/300/200?random=8"),
            Video(id: "9", title: "Space Discovery", description: "New findings", thumbnailURL: "https://picsum.photos/300/200?random=9")
        ]
    }
}

// MARK: - Category View
struct CategoryView: View {
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

// MARK: - Preview
#Preview {
    SearchView()
        .environmentObject(SignInViewModel())
        .environmentObject(VideoManager())
}
