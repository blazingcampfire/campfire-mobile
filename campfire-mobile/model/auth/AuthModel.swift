//
//  LoginFlowModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/9/23.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseStorage



@MainActor
final class AuthModel: ObservableObject {
    // Input values from Views
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var profilePic: String = ""
    @Published var userID: String = ""

    // Validity booleans
    @Published var validUser: Bool = false
    @Published var validPhoneNumber: Bool = false
    @Published var validVerificationCodeLength: Bool = false
    @Published var validVerificationCode: Bool = false
    @Published var validEmailString: Bool = false
    @Published var validEmail: Bool = false
    @Published var validName: Bool = false
    @Published var emailSignInSuccess: Bool = false
    @Published var validUsername: Bool = false
    
    // Bools for whether user is creating account or logging in
    @Published var login: Bool = false
    @Published var createAccount: Bool = false

    // Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    // VerificationCode from firebase
    var firebaseVerificationCode: String = ""

    private var publishers = Set<AnyCancellable>()

    // Initializing validity publishers
    init() {
        isPhoneNumberValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validPhoneNumber, on: self)
            .store(in: &publishers)
        isVerificationCodeValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validVerificationCodeLength, on: self)
            .store(in: &publishers)
        isEmailStringValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validEmailString, on: self)
            .store(in: &publishers)
        isNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validName, on: self)
            .store(in: &publishers)
        isUserNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validUsername, on: self)
            .store(in: &publishers)
    }
}

// MARK: - Extension: Validation setup

private extension AuthModel {
    var isPhoneNumberValidPublisher: AnyPublisher<Bool, Never> {
        $phoneNumber
            .map {
                number in
                number.count == 11
            }
            .eraseToAnyPublisher()
    }

    var isVerificationCodeValidPublisher: AnyPublisher<Bool, Never> {
        $verificationCode
            .map {
                code in
                code.count == 6
            }
            .eraseToAnyPublisher()
    }

    var isEmailStringValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                // has a valid "@." email
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                var validEmail: Bool = emailPredicate.evaluate(with: email) && email.hasSuffix(".edu") && schoolValidator(email: email)
                return validEmail
            }
            .eraseToAnyPublisher()
    }
    
    var isNameValidPublisher: AnyPublisher<Bool, Never> {
        $name
            .map {
                name in
                name.count >= 2
            }
            .eraseToAnyPublisher()
    }

    var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map {
                name in
                name.count >= 3
            }
            .eraseToAnyPublisher()
    }

    var isProfilePicValidPublisher: AnyPublisher<Bool, Never> {
        $profilePic
            .map {
                string in
                string.count > 0
            }
            .eraseToAnyPublisher()
    }

}

// MARK: - Extension: All Firebase API Authentication logic for the login views

extension AuthModel {
    func getVerificationCode() {
        UIApplication.shared.closeKeyboard()
        Task {
            do {
                // MARK: - Disable when testing with real device

                Auth.auth().settings?.isAppVerificationDisabledForTesting = true

                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(phoneNumber)", uiDelegate: nil)
                await MainActor.run(body: {
                    firebaseVerificationCode = code
                })
            } catch {
                await handleError(error: error)
            }
        }
    }

    func verifyVerificationCode() {
        UIApplication.shared.closeKeyboard()
        Task {
            do {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: firebaseVerificationCode, verificationCode: verificationCode)

                try await Auth.auth().signIn(with: credential)

                // MARK: User phone number authenticated successfully

                print("Success!")
                self.validVerificationCode = true
            } catch {
                await handleError(error: error)
            }
        }
    }
}

// MARK: - Google auth

extension AuthModel {
    func signInGoogle() async throws {
        do {
            let helper = SignInGoogleHelper()
            let tokens = try await helper.signIn()
            try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        }
        catch {
            await handleError(error: error)
        }
    }

    func signUpGoogle() async throws {
        do {
            let helper = SignInGoogleHelper()
            let tokens = try await helper.signIn()
            try await AuthenticationManager.shared.signUpWithGoogle(tokens: tokens)
        }
        catch {
            await handleError(error: error)
        }
    }
    

    // MARK: - Handling errors

    func handleError(error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

// MARK: - Create user function

extension AuthModel {
    
    func createProfile() {
        
        userID = Auth.auth().currentUser!.uid
        email = Auth.auth().currentUser?.email ?? self.email
        phoneNumber = Auth.auth().currentUser?.phoneNumber ?? self.phoneNumber
        
        let school: String = schoolParser(email: email)
        let nameInsensitive: String = name.lowercased()
        
        var userRef: CollectionReference
        var profileRef: CollectionReference
        
        if school == "nd" {
            userRef = ndUsers
            profileRef = ndProfiles
        }
        else if school == "yale" {
            userRef = yaleUsers
            profileRef = yaleUsers
        }
        else if school == "rice" {
            userRef = riceUsers
            profileRef = riceUsers
        }
        else {
            return
        }
        
        let profileData = Profile(name: name, nameInsensitive: nameInsensitive, phoneNumber: phoneNumber , email: email, username: self.username, posts: [[:]], postData: [[:]], chocs: 0, userID: userID, school: school, bio: "")
        
        let userData = privateUser(phoneNumber: phoneNumber, email: email, userID: userID, school: school)
       
        
        // based on the user's school, their profile document is sorted into the appropriate school document
        
        do {
            try userRef.document("\(userID)").setData(from: userData)
            try profileRef.document("\(userID)").setData(from: profileData)
            print("Documents successfully written!")
        }
        catch {
            print("Error writing profile or user to firestore \(error)")
        }
    }
}


// MARK: - Extension to UIApplication for setup of closeKeyboard function

private extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
