//
//  SearchBar.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

//struct SearchBar: UIViewRepresentable {
//    @Binding var text: String
//    var onTextChange: () -> Void
//    var onClear: () -> Void
//
//    class Coordinator: NSObject, UISearchBarDelegate {
//        @Binding var text: String
//        var onTextChange: () -> Void
//        var onClear: () -> Void
//
//        init(text: Binding<String>, onTextChange: @escaping () -> Void, onClear: @escaping () -> Void) {
//            _text = text
//            self.onTextChange = onTextChange
//            self.onClear = onClear
//        }
//
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//            onTextChange()
//        }
//
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            searchBar.resignFirstResponder()
//        }
//
//        func searchBar(_ searchBar: UISearchBar, didChange searchText: String) {
//            if searchText.isEmpty {
//                text = ""
//                onClear()
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(text: $text, onTextChange: onTextChange, onClear: onClear)
//    }
//
//    func makeUIView(context: Context) -> UISearchBar {
//        let searchBar = UISearchBar(frame: .zero)
//        searchBar.delegate = context.coordinator
//        searchBar.placeholder = "What's on your mind?"
//        searchBar.showsCancelButton = false
//        searchBar.searchBarStyle = .minimal
//        searchBar.backgroundImage = UIImage()  // Remove the background
//        searchBar.layer.cornerRadius = 10
//        searchBar.clipsToBounds = true
//        return searchBar
//    }
//
//    func updateUIView(_ uiView: UISearchBar, context: Context) {
//        uiView.text = text
//    }
//}
