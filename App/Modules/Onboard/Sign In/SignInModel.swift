//
//  SignInModel.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI
import AuthenticationServices
import CloudKit

// MARK: - Constant
let container = CKContainer(identifier: "iCloud.com.waked.Streamify")

// MARK: Successful Login
func handleSuccessfulLogin(with authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email

        let record = CKRecord(recordType: "Accounts")
        record["userIdentifier"] = userIdentifier
        record["givenName"] = fullName?.givenName
        record["familyName"] = fullName?.familyName
        record["email"] = email

        let publicDatabase = container.publicCloudDatabase
        publicDatabase.save(record) { (savedRecord, error) in
            if let error = error {
                print("Error saving user to CloudKit: \(error.localizedDescription)")
            } else {
                print("User successfully saved to CloudKit")
            }
        }
    }
}

// MARK: - Unsuccessful Login
func handleLoginError(with error: Error) {
    print("Could not authenticate: \(error.localizedDescription)")
}

// MARK: - Fetch User Data
func fetchUserData(userIdentifier: String, completion: @escaping (CKRecord?) -> Void) {
    let predicate = NSPredicate(format: "userIdentifier == %@", userIdentifier)
    let query = CKQuery(recordType: "Accounts", predicate: predicate)
    
    let publicDatabase = container.publicCloudDatabase
    publicDatabase.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 1) { result in
            switch result {
            case .success(let (matchResults, _)):
                if let record = try? matchResults.first?.1.get() {
                    completion(record)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
                completion(nil)
            }
        }
}

// MARK: - View Model
class SignInViewModel: ObservableObject {
    @Published var isSignedIn: Bool {
        didSet {
            UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
            print("SignInViewModel: isSignedIn set to: \(isSignedIn)")
        }
    }
    @Published var userName: String?
    @Published var userIdentifier: String? {
        didSet {
            if let userIdentifier = userIdentifier {
                UserDefaults.standard.set(userIdentifier, forKey: "userIdentifier")
                print("SignInViewModel: userIdentifier saved: \(userIdentifier)")
            } else {
                UserDefaults.standard.removeObject(forKey: "userIdentifier")
                print("SignInViewModel: userIdentifier removed from UserDefaults")
            }
        }
    }
    
    init() {
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        self.userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier")
        print("Initializing SignInViewModel - isSignedIn: \(self.isSignedIn), userIdentifier: \(self.userIdentifier ?? "nil")")
        
        if let userIdentifier = self.userIdentifier {
            fetchUserData(userIdentifier: userIdentifier) { [weak self] record in
                DispatchQueue.main.async {
                    self?.userName = record?["givenName"] as? String
                    print("userName set to: \(self?.userName ?? "nil")")
                }
            }
        }
    }
    
    func signIn(with authorization: ASAuthorization?) {
        if let authorization = authorization {
            handleSuccessfulLogin(with: authorization)
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                userIdentifier = appleIDCredential.user
                print("Sign in successful. User Identifier: \(userIdentifier ?? "Not available")")
                fetchUserData(userIdentifier: appleIDCredential.user) { [weak self] record in
                    DispatchQueue.main.async {
                        self?.userName = record?["givenName"] as? String
                        print("userName set to: \(self?.userName ?? "nil")")
                    }
                }
            }
        } else {
            // Guest sign in
            userIdentifier = "guest_\(UUID().uuidString)"
            userName = "Guest User"
            print("Guest sign in successful. User Identifier: \(userIdentifier ?? "Not available")")
        }
        isSignedIn = true
    }
    
    func signOut() {
        print("SignInViewModel: Signing out")
        isSignedIn = false
        userIdentifier = nil
        userName = nil
        print("SignInViewModel: User signed out")
    }
}
