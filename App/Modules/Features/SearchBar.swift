//
//  SearchBar.swift
//  App
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - Minimal SearchBar View
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $text)
                .foregroundColor(.primary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(Color(.systemGray5))
        .cornerRadius(8.0)
        .padding(.horizontal, 10)
    }
}
