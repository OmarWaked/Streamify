//
//  StreamifyApp.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

@main
struct StreamifyApp: App {
    @StateObject private var signInViewModel = SignInViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(signInViewModel)
        }
    }
}
