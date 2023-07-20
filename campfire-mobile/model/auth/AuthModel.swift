//
//  LoginFlowModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/9/23.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import GoogleSignIn
import GoogleSignInSwift


@MainActor
final class AuthModel: ObservableObject {
    // Input values from Views
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var profilePic: String = ""

    // Validity booleans
    @Published var validUser: Bool = false
    @Published var validPhoneNumber: Bool = false
    @Published var validVerificationCodeLength: Bool = false
    @Published var validVerificationCode: Bool = false
    @Published var validEmailString: Bool = false
    @Published var validEmail: Bool = false
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
        isUserValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validUser, on: self)
            .store(in: &publishers)
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

    var isUserValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isPhoneNumberValidPublisher, isVerificationCodeValidPublisher, isUserNameValidPublisher, isEmailStringValidPublisher)
            .map { isPhoneNumberValid, isVerificationCodeValid, isUsernameValid, isEmailValid in
                isPhoneNumberValid && isVerificationCodeValid && isUsernameValid && isEmailValid
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
        
        var user = ["phoneNumber": self.phoneNumber, "email": self.email, "username": self.username, "chocs": 0] as [String : Any]

        ndProfiles.document("Adarsh").setData(user) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}


// MARK: - Extension to UIApplication for setup of closeKeyboard function

private extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
