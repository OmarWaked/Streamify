//
//  CitizenshipModel.swift
//  App
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import Foundation
import SwiftUI

// MARK: - Constants
var allCountries = [
    Country(name: "Portugal", emoji: "🇵🇹", requirements: """
    1. Residency Requirements:
       - Minimum of 5 years of legal residency in Portugal.

    2. Integration:
       - Demonstrate integration into Portuguese society.
       - Knowledge of the Portuguese language.
       - Respect for Portuguese law and values.

    3. Language Proficiency:
       - Proficiency in Portuguese (A2 level in the Common European Framework of Reference for Languages).

    4. Civic Knowledge:
       - Basic knowledge of Portuguese geography, history, and political system.
       - May be assessed through interviews or tests.

    5. Financial Stability:
       - Proof of income or financial means to support oneself.
       
    Golden Visa Program:
       - Investment of at least EUR 500,000 in real estate.
       - Alternative investments include capital transfer of EUR 1 million or creation of 10 jobs.
    """),
    Country(name: "Spain", emoji: "🇪🇸", requirements: """
    1. Residency Requirements:
       - Minimum of 10 years of legal residency in Spain (reduced to 5 years for refugees, 2 years for nationals from Ibero-American countries, Andorra, the Philippines, Equatorial Guinea, Portugal, or Sephardic Jews).

    2. Integration:
       - Demonstrate integration into Spanish society.
       - Knowledge of the Spanish language.
       - Respect for Spanish law and values.

    3. Language Proficiency:
       - Proficiency in Spanish (A2 level in the Common European Framework of Reference for Languages).

    4. Civic Knowledge:
       - Basic knowledge of Spanish geography, history, and political system.
       - Pass the CCSE (Constitutional and Sociocultural Knowledge of Spain) test.

    5. Financial Stability:
       - Proof of income or financial means to support oneself.
       
    Golden Visa Program:
       - Investment of at least EUR 500,000 in real estate.
    """),
    Country(name: "Greece", emoji: "🇬🇷", requirements: """
    1. Residency Requirements:
       - Minimum of 7 years of legal residency in Greece.

    2. Integration:
       - Demonstrate integration into Greek society.
       - Knowledge of the Greek language.
       - Respect for Greek law and values.

    3. Language Proficiency:
       - Proficiency in Greek (A2 level in the Common European Framework of Reference for Languages).

    4. Civic Knowledge:
       - Basic knowledge of Greek geography, history, and political system.

    5. Financial Stability:
       - Proof of income or financial means to support oneself.
       
    Golden Visa Program:
       - Minimum real estate investment of EUR 250,000.
    """),
    Country(name: "Switzerland", emoji: "🇨🇭", requirements: """
    1. Residency Requirements:
       - Ordinary Naturalization: Typically requires 10 years of residency in Switzerland.
       - Simplified Naturalization: May apply to spouses of Swiss citizens or children of Swiss parents, typically requiring a shorter residency period (usually 5 years for spouses).

    2. Integration:
       - Demonstrate integration into Swiss society.
       - Respect for Swiss law and values.
       - Participation in economic life (employment or education).
       - Adequate knowledge of a national language (German, French, Italian, or Romansh).

    3. Language Proficiency:
       - Proficiency in one of the national languages.
       - Language requirements vary by canton but typically require at least level B1 for speaking and A2 for writing (based on the Common European Framework of Reference for Languages).

    4. Civic Knowledge:
       - Basic knowledge of Swiss geography, history, political system, and values.
       - May be assessed through interviews or tests.

    5. Financial Stability:
       - No reliance on social welfare benefits in the years preceding the application.
       - Demonstrate financial self-sufficiency.
    """),
    Country(name: "Sweden", emoji: "🇸🇪", requirements: """
    1. Residency Requirements:
       - Minimum of 5 years of legal residency in Sweden.

    2. Integration:
       - Demonstrate integration into Swedish society.
       - Respect for Swedish law and values.
       - Participation in economic life (employment or education).

    3. Language Proficiency:
       - Adequate knowledge of Swedish, though specific language requirements are not strictly enforced.

    4. Civic Knowledge:
       - Basic knowledge of Swedish geography, history, and political system.

    5. Financial Stability:
       - Proof of income or financial means to support oneself.
    """),
    Country(name: "Ireland", emoji: "🇮🇪", requirements: """
    1. Residency Requirements:
       - Minimum of 5 years of legal residency in Ireland (reduced to 3 years for spouses of Irish citizens).

    2. Integration:
       - Demonstrate integration into Irish society.
       - Knowledge of the English or Irish language.
       - Respect for Irish law and values.

    3. Language Proficiency:
       - Proficiency in English or Irish.

    4. Civic Knowledge:
       - Basic knowledge of Irish geography, history, and political system.

    5. Financial Stability:
       - Proof of income or financial means to support oneself.
    """),
    Country(name: "Norway", emoji: "🇳🇴", requirements: """
    1. Residency Requirements:
       - Minimum of 7 years of legal residency in Norway.

    2. Integration:
       - Demonstrate integration into Norwegian society.
       - Knowledge of the Norwegian language.
       - Respect for Norwegian law and values.

    3. Language Proficiency:
       - Proficiency in Norwegian (B1 level in the Common European Framework of Reference for Languages).

    4. Civic Knowledge:
       - Basic knowledge of Norwegian geography, history, and political system.

    5. Financial Stability:
       - Proof of income or financial means to support oneself.
    """)
].sorted {$0.name < $1.name}

// MARK: - Structures
struct Country: Identifiable, Equatable, Codable {
    let id = UUID()
    let name: String
    let emoji: String
    let requirements: String
}

class CitizenshipPlan: ObservableObject {
    @Published var inProgressCountries: [Country] = [] {
        didSet {
            saveInProgressCountries()
        }
    }
    
    @Published var todoList: [UUID] = [] {
        didSet {
            saveTodoList()
        }
    }
    
    init() {
        loadInProgressCountries()
        loadTodoList()
    }
    
    func addCountry(_ country: Country) {
        if !inProgressCountries.contains(country) {
            inProgressCountries.append(country)
            saveInProgressCountries()
        }
    }
    
    func removeCountry(_ country: Country) {
        if let index = inProgressCountries.firstIndex(of: country) {
            inProgressCountries.remove(at: index)
            saveInProgressCountries()
        }
    }
    
    private func saveInProgressCountries() {
        if let encoded = try? JSONEncoder().encode(inProgressCountries) {
            UserDefaults.standard.set(encoded, forKey: "inProgressCountries")
        }
    }
    
    private func loadInProgressCountries() {
        if let savedData = UserDefaults.standard.data(forKey: "inProgressCountries"),
           let decoded = try? JSONDecoder().decode([Country].self, from: savedData) {
            inProgressCountries = decoded
        }
    }
    
    private func saveTodoList() {
        if let encoded = try? JSONEncoder().encode(todoList) {
            UserDefaults.standard.set(encoded, forKey: "todoList")
        }
    }
    
    private func loadTodoList() {
        if let savedData = UserDefaults.standard.data(forKey: "todoList"),
           let decoded = try? JSONDecoder().decode([UUID].self, from: savedData) {
            todoList = decoded
        }
    }
}
