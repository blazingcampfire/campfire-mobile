//
//  LoginFlowModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/9/23.
//

import Foundation
import Combine

final class authModel: ObservableObject {
    
    // input values from Views
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var profilePic: String = ""
    
    // validity booleans
    @Published var validUser: Bool = false
    @Published var validPhoneNumber: Bool = false
    @Published var validVerificationCode: Bool = false
    @Published var validEmail: Bool = false
    @Published var validUsername: Bool = false
    @Published var validProfilePic: Bool = false
   
    
    // verificationCode from firebase
    var firebaseVerificationCode: String = "123456"
    
    private var publishers = Set<AnyCancellable>()
    
    // initializing validity publishers
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

// MARK: - Validation setup
private extension authModel {
    
    var isPhoneNumberValidPublisher: AnyPublisher<Bool, Never> {
        $phoneNumber
            .map {
                number in
                return number.count == 10
            }
            .eraseToAnyPublisher()
    }
    
    var isVerificationCodeValidPublisher: AnyPublisher<Bool, Never> {
        $verificationCode
            .map {
                code in
                return code == self.firebaseVerificationCode
            }
            .eraseToAnyPublisher()

    }
    
    
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { email in
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
