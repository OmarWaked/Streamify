//
//  HomeView.swift
//  App
//
//  Created by Rayan Waked on 7/13/24.
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
                    Text(getGreeting(for: signInViewModel.userName))
                        .font(.largeTitle)
                        .bold()
                        .padding()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
