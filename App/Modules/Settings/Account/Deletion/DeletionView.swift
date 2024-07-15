//
//  DeletionView.swift
//  App
//
//  Created by Rayan Waked on 7/14/24.
//

//MARK: - Import
import SwiftUI

// MARK: - View
struct DeletionView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    var body: some View {
        deleteButton
    }
}

// MARK: - Extension
private extension DeletionView {
    var deleteButton: some View {
        Button("Delete Account") {
            signInViewModel.initiateAccountDeletion { result in
                switch result {
                case .success:
                    print("Account deleted successfully")
                    // Handle successful deletion
                case .failure(let error):
                    print("Failed to delete account: \(error.localizedDescription)")
                    // Handle failure (e.g., show an alert to the user)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DeletionView()
}
