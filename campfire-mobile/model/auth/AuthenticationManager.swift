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
    
    // logic still in progress
    func signUpWithGoogle(tokens: GoogleSignInResultModel) async throws {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        if let user = Auth.auth().currentUser {
            try await user.link(with: credential)
            let email = Auth.auth().currentUser?.email!
            print(email)
            if !schoolValidator(email: email!)
            {
                print("The email you are trying to sign up with either does not match the one you input earlier, or it is associated with a school that we do not yet support.")
                try await Auth.auth().currentUser?.delete()
            }
        }
        
    }
    


}
