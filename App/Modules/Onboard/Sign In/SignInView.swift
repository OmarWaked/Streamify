//
//  SignInView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI
import AuthenticationServices

// MARK: - View
struct SignInView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    var body: some View {
        appleIdButton
    }
}

// MARK: - Extension
private extension SignInView {
    var appleIdButton: some View {
        SignInWithAppleButton(.signUp) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                signInViewModel.signIn(with: authorization)
            case .failure(let error):
                handleLoginError(with: error)
            }
        }
        .frame(height: 50)
        .padding()
    }
    
    var header: some View {
        Text("Account")
    }
}

// MARK: - Preview
#Preview {
    SignInView()
}
