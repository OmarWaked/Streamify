//
//  Constants.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import UIKit
import SwiftUI

// MARK: - Size
let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height

extension Color {
    static let Gamboge = Color(hex: "f0a202")
    static let Tangerine = Color(hex: "f18805")
    static let Cinnabar = Color(hex: "d95d39")
    static let OxfordBlue = Color(hex: "0e1428")
    static let CambridgeBlue = Color(hex: "7b9e89")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0xff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
