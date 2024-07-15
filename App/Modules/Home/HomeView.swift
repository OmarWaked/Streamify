//
//  HomeView.swift
//  App
//
//  Created by Rayan Waked on 7/13/24.
//

// MARK: - Import
import SwiftUI

//MARK: - Constant
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

// MARK: - View
struct HomeView: View {
    @StateObject private var citizenshipPlan = CitizenshipPlan()
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
                    
                    if !citizenshipPlan.inProgressCountries.isEmpty {
                        Text("In Progress")
                            .font(.title)
                            .padding(.top)
                            .padding(.leading, 5)
                        
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(citizenshipPlan.inProgressCountries) { country in
                                NavigationLink(destination: CountryDetailView(country: country)) {
                                    VStack {
                                        Text(country.emoji)
                                            .font(.largeTitle)
                                        Text(country.name)
                                            .font(.system(size: 14))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(1)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    Text("Available Countries")
                        .font(.title)
                        .padding(.top)
                        .padding(.leading, 5)
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(allCountries.filter { !citizenshipPlan.inProgressCountries.contains($0) }) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                VStack {
                                    Text(country.emoji)
                                        .font(.largeTitle)
                                    Text(country.name)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
        .environmentObject(citizenshipPlan)
    }
}

// MARK: - Country Card
struct CountryCard: View {
    let countryName: String
    let flagEmoji: String
    
    var body: some View {
        VStack {
            Text(flagEmoji)
                .font(.system(size: 80))
                .frame(width: 100, height: 100)
                .background(Color.white)
                .cornerRadius(10)
            Text(countryName)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 10)
        }
        .frame(width: 120, height: 150)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
