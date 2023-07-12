//
//  LoginFlowModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/9/23.
//

import Foundation
import Combine
import Firebase

final class authModel: ObservableObject {
    
    // Input values from Views
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var profilePic: String = ""
    
    // Validity booleans
    @Published var validUser: Bool = false
    @Published var validPhoneNumber: Bool = false
    @Published var validVerificationCode: Bool = false
    @Published var validEmail: Bool = false
    @Published var validUsername: Bool = false
    @Published var validProfilePic: Bool = false
    
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
            .assign(to: \.validVerificationCode, on: self)
            .store(in: &publishers)
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validEmail, on: self)
            .store(in: &publishers)
        isUserNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validUsername, on: self)
            .store(in: &publishers)
        isProfilePicValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validProfilePic, on: self)
            .store(in: &publishers)
    }
    
}

// MARK: - Extension: Validation setup
private extension authModel {
    
    var isPhoneNumberValidPublisher: AnyPublisher<Bool, Never> {
        $phoneNumber
            .map {
                number in
                return number.count == 11
            }
            .eraseToAnyPublisher()
    }
    
    var isVerificationCodeValidPublisher: AnyPublisher<Bool, Never> {
        $verificationCode
            .map {
                code in
                return code.count == 6
            }
            .eraseToAnyPublisher()

    }
    
    
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                // has a valid "@." email
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map {
                name in
                return name.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    var isProfilePicValidPublisher: AnyPublisher<Bool, Never> {
        $profilePic
            .map {
                string in
                return string.count > 0
            }
            .eraseToAnyPublisher()
    }
    
    var isUserValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isPhoneNumberValidPublisher, isVerificationCodeValidPublisher, isUserNameValidPublisher, isEmailValidPublisher)
            .map { isPhoneNumberValid, isVerificationCodeValid, isUsernameValid, isEmailValid in
                return isPhoneNumberValid && isVerificationCodeValid && isUsernameValid && isEmailValid
            }
            .eraseToAnyPublisher()
    }
    
    
    
}

// MARK: - Extension: All Firebase API Authentication logic for the login views
extension authModel {
    
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
            }
            catch {
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
            }
            catch {
                await handleError(error: error)
            }
        }
    }
    // MARK: Handling Errors
    func handleError(error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

// MARK: - Extension to UIApplication for setup of closeKeyboard function
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
