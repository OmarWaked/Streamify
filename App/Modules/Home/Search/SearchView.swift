//
//  SearchView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct YouTubeVideo: Identifiable {
    var id: String
    var title: String
    var description: String
    var thumbnailURL: String
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onTextChange: () -> Void
    var onClear: () -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onTextChange: () -> Void
        var onClear: () -> Void

        init(text: Binding<String>, onTextChange: @escaping () -> Void, onClear: @escaping () -> Void) {
            _text = text
            self.onTextChange = onTextChange
            self.onClear = onClear
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onTextChange()
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }

        func searchBar(_ searchBar: UISearchBar, didChange searchText: String) {
            if searchText.isEmpty {
                text = ""
                onClear()
                searchBar.resignFirstResponder()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onTextChange: onTextChange, onClear: onClear)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search YouTube"
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()  // Remove the background
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

struct YouTubeSearchView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [YouTubeVideo] = []
    
    @State private var recentlyPlayed: [YouTubeVideo] = [
        YouTubeVideo(id: "1", title: "Recently Played 1", description: "Description 1", thumbnailURL: "https://img.youtube.com/vi/1/default.jpg"),
        // Add more mock videos
    ]
    
    @State private var recommended: [YouTubeVideo] = [
        YouTubeVideo(id: "2", title: "Recommended 1", description: "Description 2", thumbnailURL: "https://img.youtube.com/vi/2/default.jpg"),
        // Add more mock videos
    ]
    
    @State private var trending: [YouTubeVideo] = [
        YouTubeVideo(id: "3", title: "Trending 1", description: "Description 3", thumbnailURL: "https://img.youtube.com/vi/3/default.jpg"),
        // Add more mock videos
    ]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    SearchBar(
                        text: $searchText,
                        onTextChange: searchYouTube,
                        onClear: clearResults
                    )
                    .padding(.top)
                    .padding(.horizontal)
                    
                    if searchResults.isEmpty {
                        VStack(alignment: .leading) {
                            CategoryView(title: "Recently Played", videos: recentlyPlayed)
                            CategoryView(title: "Recommended", videos: recommended)
                            CategoryView(title: "Trending", videos: trending)
                        }
                    } else {
                        List(searchResults) { video in
                            HStack {
                                if let url = URL(string: video.thumbnailURL) {
                                    AsyncImage(url: url)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(10)
                                        .padding(.trailing, 10)
                                }
                                VStack(alignment: .leading) {
                                    Text(video.title)
                                        .font(.headline)
                                    Text(video.description)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                .navigationTitle("Search YouTube")
            }
        }
    }

    func searchYouTube() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        // Mock implementation - replace with actual YouTube API call
        let mockResults = [
            YouTubeVideo(id: "3JZ_D3ELwOQ", title: "Never Gonna Give You Up", description: "Rick Astley - Never Gonna Give You Up (Official Music Video)", thumbnailURL: "https://img.youtube.com/vi/3JZ_D3ELwOQ/default.jpg"),
            YouTubeVideo(id: "dQw4w9WgXcQ", title: "Mock Video", description: "Mock Description", thumbnailURL: "https://img.youtube.com/vi/dQw4w9WgXcQ/default.jpg")
        ]
        searchResults = mockResults.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
    }

    func clearResults() {
        searchText = ""
        searchResults = []
    }
}

struct CategoryView: View {
    var title: String
    var videos: [YouTubeVideo]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(videos) { video in
                        VStack {
                            if let url = URL(string: video.thumbnailURL) {
                                AsyncImage(url: url)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                            }
                            Text(video.title)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .padding(.leading, 5)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

