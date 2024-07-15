//
//  SettingsView.swift
//  App
//
//  Created by Rayan Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct SettingsView: View {
    var body: some View {
        VStack {
            logOut
        }
    }
}

// MARK: - Extension
private extension SettingsView {
    var logOut: some View {
        DeletionView()
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
