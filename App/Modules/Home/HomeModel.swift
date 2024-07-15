//
//  HomeModel.swift
//  Solis
//
//  Created by Rayan Waked on 7/13/24.
//

// MARK: - Import
import SwiftUI

// MARK: - Function
func getGreeting(for userName: String?) -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    let name = userName ?? ""
    
    switch hour {
    case 6..<12:
        return "Good Morning \(name)"
    case 12..<18:
        return "Good Afternoon \(name)"
    default:
        return "Good Evening \(name)"
    }
}
