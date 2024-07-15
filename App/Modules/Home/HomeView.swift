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

    var body: some View {
        VStack {
            content
        }
    }
}

// MARK: - Extension
private extension HomeView {
    var content: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                }.navigationTitle(getGreeting(for: signInViewModel.userName))
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
