//
//  CountryDetailView.swift
//  App
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI

struct CountryDetail: Identifiable, Hashable {
    let id = UUID()
    let subtitle: String
    let text: String
}

struct CountryDetailView: View {
    let country: Country
    @EnvironmentObject var citizenshipPlan: CitizenshipPlan
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showNavigationBarTitle = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
                    }
                    .frame(height: 0)
                    
                    Text(country.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)
                    
                    ForEach(countryDetails(), id: \.id) { detail in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(detail.subtitle)
                                .font(.title2)
                                .bold()
                            Text(detail.text)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    if citizenshipPlan.inProgressCountries.contains(country) {
                        HStack {
                            Spacer()
                            Button(action: {
                                removeFromPlan()
                            }) {
                                Text("Remove from Plan")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.top)
                            }
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button(action: {
                                addToPlan()
                            }) {
                                Text("Add to Plan")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.top)
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ViewOffsetKey.self) { value in
                if value < -50 {
                    withAnimation {
                        showNavigationBarTitle = true
                    }
                } else {
                    withAnimation {
                        showNavigationBarTitle = false
                    }
                }
            }
            .blur(radius: showToast ? 3 : 0)
            
            if showToast {
                VStack {
                    Spacer()
                    ToastView(message: toastMessage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                    Spacer()
                }
            }
        }
        .navigationBarTitle(showNavigationBarTitle ? country.name : "", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            toggleTodoList()
        }) {
            Image(systemName: citizenshipPlan.todoList.contains(country.id) ? "checkmark.circle.fill" : "checkmark.circle")
                .foregroundColor(citizenshipPlan.todoList.contains(country.id) ? Color.green : Color.primary)
        })
    }
    
    private func addToPlan() {
        citizenshipPlan.addCountry(country)
    }
    
    private func removeFromPlan() {
        citizenshipPlan.removeCountry(country)
    }
    
    private func toggleTodoList() {
        if citizenshipPlan.todoList.contains(country.id) {
            citizenshipPlan.todoList.removeAll { $0 == country.id }
            showToastMessage("Removed tasks for \(country.name) from your to-do list")
        } else {
            citizenshipPlan.todoList.append(country.id)
            showToastMessage("Successfully added tasks for \(country.name) to your to-do list")
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
    }
    
    private func countryDetails() -> [CountryDetail] {
        var details = [CountryDetail]()
        let sections = country.requirements.components(separatedBy: "\n\n")
        
        for section in sections {
            let parts = section.components(separatedBy: "\n")
            if parts.count >= 2 {
                let subtitle = parts[0]
                let text = parts.dropFirst().joined(separator: "\n")
                details.append(CountryDetail(subtitle: subtitle, text: text))
            }
        }
        
        return details
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .shadow(radius: 10)
    }
}
