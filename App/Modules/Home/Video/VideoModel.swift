//
//  VideoModel.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import Foundation

//struct YouTubeVideo: Identifiable {
//    var id: String
//    var title: String
//    var description: String
//    var thumbnailURL: String
//}

struct Playlist: Identifiable {
    var id: UUID
    var name: String
    var videos: [YouTubeVideo]
}

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    var videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "https://www.youtube.com/embed/\(videoID)") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
