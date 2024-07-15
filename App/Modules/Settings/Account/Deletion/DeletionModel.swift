//
//  DeletionModel.swift
//  App
//
//  Created by Rayan Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI
import CloudKit

// MARK: - Manager
class AccountDeletionManager {
    // MARK: - Constant
    static let shared = AccountDeletionManager()
    private let container = CKContainer(identifier: "iCloud.com.waked.Streamify")
    private init() {}
    
    // MARK: - Delete FUnction
    func deleteAccount(userIdentifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("AccountDeletionManager: Attempting to delete account for userIdentifier: \(userIdentifier)")
        let predicate = NSPredicate(format: "userIdentifier == %@", userIdentifier)
        let query = CKQuery(recordType: "Accounts", predicate: predicate)
        
        let publicDatabase = container.publicCloudDatabase
        publicDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            if let error = error {
                print("AccountDeletionManager: Error performing query: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let recordToDelete = records?.first else {
                print("AccountDeletionManager: No account found to delete for userIdentifier: \(userIdentifier)")
                completion(.failure(NSError(domain: "AccountDeletion", code: 404, userInfo: [NSLocalizedDescriptionKey: "No account found to delete"])))
                return
            }
            
            print("AccountDeletionManager: Account found. Proceeding with deletion.")
            self?.deleteRecord(recordID: recordToDelete.recordID, completion: completion)
        }
    }
    
    // MARK: - Delete Record
    private func deleteRecord(recordID: CKRecord.ID, completion: @escaping (Result<Void, Error>) -> Void) {
        let publicDatabase = container.publicCloudDatabase
        publicDatabase.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("AccountDeletionManager: Error deleting record: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("AccountDeletionManager: Account successfully deleted")
                completion(.success(()))
            }
        }
    }
}

// MARK: - Extension View Model
extension SignInViewModel {
    func initiateAccountDeletion(completion: @escaping (Result<Void, Error>) -> Void) {
        print("SignInViewModel: Initiating account deletion.")
        print("SignInViewModel: Current isSignedIn: \(isSignedIn)")
        print("SignInViewModel: Current userIdentifier: \(userIdentifier ?? "Not available")")
        print("SignInViewModel: Current userName: \(userName ?? "Not available")")
        
        guard let userIdentifier = userIdentifier else {
            print("SignInViewModel: User identifier not found. Make sure the user is signed in.")
            completion(.failure(NSError(domain: "AccountDeletion", code: 400, userInfo: [NSLocalizedDescriptionKey: "User identifier not found. Make sure the user is signed in."])))
            return
        }
        
        AccountDeletionManager.shared.deleteAccount(userIdentifier: userIdentifier) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("SignInViewModel: Account deletion successful. Signing out.")
                    self?.signOut()
                case .failure(let error):
                    print("SignInViewModel: Failed to delete account: \(error.localizedDescription)")
                }
                completion(result)
            }
        }
    }
}
