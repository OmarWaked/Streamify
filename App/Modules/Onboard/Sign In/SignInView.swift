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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            Spacer()
            
            // Sign in options
            signInOptions
            
            Spacer()
            
            // Footer
            footer
        }
        .background(backgroundGradient)
        .ignoresSafeArea()
    }
}

// MARK: - Extension
private extension SignInView {
    var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var header: some View {
        VStack(spacing: 16) {
            // App icon placeholder
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 8) {
                Text("Join Streamify")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Sign in to access your personalized streaming experience")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding(.top, 60)
    }
    
    var signInOptions: some View {
        VStack(spacing: 20) {
            // Apple Sign In
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                handleSignInResult(result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 56)
            .cornerRadius(28)
            .padding(.horizontal, 32)
            
            // Guest Sign In
            Button(action: signInAsGuest) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                    Text("Continue as Guest")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
            .padding(.horizontal, 32)
            
            // Terms and Privacy
            VStack(spacing: 8) {
                Text("By continuing, you agree to our")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 4) {
                    Button("Terms of Service") {
                        // Show terms
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    
                    Text("and")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button("Privacy Policy") {
                        // Show privacy policy
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                }
            }
            .padding(.top, 20)
        }
    }
    
    var footer: some View {
        VStack(spacing: 16) {
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
                
                Text("or")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 32)
            
            // Back to onboarding
            Button("Back to Onboarding") {
                dismiss()
            }
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, 40)
        }
    }
    
    func handleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            signInViewModel.signIn(with: authorization)
        case .failure(let error):
            handleLoginError(with: error)
        }
    }
    
    func signInAsGuest() {
        // For guest access, we'll just call the sign in method directly
        // In a real app, you might create a guest user account
        signInViewModel.signIn(with: nil)
    }
}

// MARK: - Custom Apple Sign In Button Style
extension SignInWithAppleButton {
    func customStyle(_ style: SignInWithAppleButton.Style) -> some View {
        self
            .signInWithAppleButtonStyle(style)
    }
}

// MARK: - Preview
#Preview {
    SignInView()
        .environmentObject(SignInViewModel())
}
