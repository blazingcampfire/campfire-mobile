//
//  AuthenticationManager.swift
//  campfire-mobile
//
//  Created by Toni on 7/14/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let phoneNumber: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL?.absoluteString
    }
}


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func deleteUser() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        Auth.auth().currentUser!.delete()
    }
    
    func unlinkCredential(providerID: String) {
        if Auth.auth().currentUser?.uid == nil {
            return
        }
        Auth.auth().currentUser?.unlink(fromProvider: providerID)
    }

    
    
    // logic still in progress
    func signUpWithGoogle(tokens: GoogleSignInResultModel) async throws {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        if let user = Auth.auth().currentUser {
            try await user.link(with: credential)
            let email = Auth.auth().currentUser?.email!
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            let validEmail: Bool = emailPredicate.evaluate(with: email) && email!.hasSuffix(".edu")
            if !schoolValidator(email: email!) || !validEmail
            {
                self.deleteUser()
                throw EmailError.noMatch
            }
            
        }
        
    }
    
    func deleteAccount(currentUser: CurrentUserModel) throws {
        do {
            currentUser.profileRef.document(currentUser.profile.userID).delete() { error in
                if let error = error {
                   return
                }
            }
            currentUser.userRef.document(currentUser.profile.userID).delete() { error in
                if let error = error {
                   return
                }
            }
            currentUser.relationshipsRef.document(currentUser.profile.userID).delete() { error in
                if let error = error {
                   return
                }
            }
        }
        self.deleteUser()
    }

}
