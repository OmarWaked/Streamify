//
//  Home.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - Function
func getGreeting(for userName: String?) -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    let name = userName ?? ""
    
    switch hour {
    case 6..<12:
        return "Good morning, \(name)"
    case 12..<18:
        return "Good afternoon, \(name)"
    default:
        return "Good evening, \(name)"
    }
}
