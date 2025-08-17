//
//  SearchModel.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

struct CustomAsyncImage: View {
    @StateObject private var loader: ImageLoader
    let placeholder: Image

    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
    }

    private var image: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                placeholder
                    .resizable()
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let uiImage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }
        task.resume()
    }
}

