//
//  LoginFlowModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/9/23.
//
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

@MainActor
final class AuthModel: ObservableObject {
    // Input values from Views
    @Published var profile: Profile = Profile(name: "", nameInsensitive: "", phoneNumber: "", email: "", username: "", posts: [], smores: 0, profilePicURL: "", userID: "", school: "", bio: "")
    @Published var privateUserData: PrivateUser = PrivateUser(phoneNumber: "", email: "", userID: "", school: "")
    @Published var phoneNumber: String = ""
    @Published var formattedPhoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var email: String = ""
    @Published var submittedEmail: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var profilePic: String = ""
    @Published var userID: String = ""

    // Validity booleans
    @Published var validUser: Bool = false
    @Published var validPhoneNumberString: Bool = false
    @Published var validPhoneNumber: Bool = false
    @Published var validVerificationCodeLength: Bool = false
    @Published var validVerificationCode: Bool = false
    @Published var validEmailString: Bool = false
    @Published var validEmail: Bool = false
    @Published var validName: Bool = false
    @Published var emailSignInSuccess: Bool = false
    @Published var validUsername: Bool = false
    @Published var isMainAppPresented: Bool = false
    @Published var restart: Bool = false

    // Bools for whether user is creating account or logging in
    @Published var login: Bool = false
    @Published var createAccount: Bool = false

    // Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    // VerificationCode from firebase
    var firebaseVerificationCode: String = ""

    private var publishers = Set<AnyCancellable>()

    // Initializing user & profile structs & validity publishers
    init() {
        isPhoneNumberValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validPhoneNumberString, on: self)
            .store(in: &publishers)
        isVerificationCodeValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validVerificationCodeLength, on: self)
            .store(in: &publishers)
        isEmailStringValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validEmailString, on: self)
            .store(in: &publishers)
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validEmail, on: self)
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

extension AuthModel {
    var isPhoneNumberValidPublisher: AnyPublisher<Bool, Never> {
        $formattedPhoneNumber
            .map {
                number in
                number.count == 14
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
                let validEmail: Bool = emailPredicate.evaluate(with: email) && email.hasSuffix(".edu") && schoolValidator(email: email)
                return validEmail
            }
            .eraseToAnyPublisher()
    }

    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $submittedEmail
            .map { submittedEmail in

                // has a valid "@.edu" email
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                let validEmail: Bool = emailPredicate.evaluate(with: submittedEmail) && submittedEmail.hasSuffix(".edu") && schoolValidator(email: submittedEmail)
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
    func formatPhoneNumber() {
        phoneNumber = formattedPhoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
    }

    func getVerificationCode() {
        UIApplication.shared.closeKeyboard()
        Task {
            do {
                // MARK: - Disable when testing with real device

                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                formatPhoneNumber()
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumber)", uiDelegate: nil)
                await MainActor.run(body: {
                    firebaseVerificationCode = code
                })
                self.validPhoneNumber = true
            } catch {
                await handleError(error: error, message: "The phone number you provided is invalid. Please try again.")
            }
        }
    }

    func verifyVerificationCode() {
        UIApplication.shared.closeKeyboard()
        Task {
            do {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: firebaseVerificationCode, verificationCode: verificationCode)

                try await Auth.auth().signIn(with: credential)
            } catch {
                await handleError(error: error, message: "The verification code you provided is invalid. Please try again.")
            }

            do {
                if Auth.auth().currentUser?.email == nil {
                    throw EmailError.noExistingUser
                }
                let existingProfile = try await self.checkProfile(email: submittedEmail)
                print(existingProfile)

                do {
                    if self.login && !existingProfile {
                        try AuthenticationManager.shared.signOut()
                        throw PhoneError.noExistingUser
                    }
                } catch {
                    await handleError(error: error, message: "No account was found matching the phone number you provided. Please finish our \("create account") flow and try again.")
                }
                do {
                    if self.createAccount && existingProfile {
                        try AuthenticationManager.shared.signOut()
                        throw PhoneError.existingUser
                    }
                } catch {
                    await handleError(error: error, message: "An account has already been created with this phone number. Please use the login option instead.")
                }
                // user phone number authenticated successfully
                self.validVerificationCode = true
            } catch {
                await handleError(error: error, message: "Unknown error trying to authenticate with this phone number. Please try again.")
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
            
            submittedEmail = (Auth.auth().currentUser?.email)!
            
            if !validEmail {
                guard let providerID = Auth.auth().currentUser?.providerData.last?.providerID else {
                    throw EmailError.noMatch
                }
                AuthenticationManager.shared.unlinkCredential(providerID: providerID)
                throw EmailError.noMatch
            } else {
                let existingProfile: Bool = try await checkProfile(email: submittedEmail)
                if !existingProfile {
                    throw EmailError.noExistingUser
                }
                else {
                    emailSignInSuccess = true
                }
            }
        } catch {
                await handleError(error: error, message: "An error occurred trying to sign in with the email you provided. Please try to sign in again.")
            }
        }

    func signUpGoogle() async throws {
        do {
            let helper = SignInGoogleHelper()
            let tokens = try await helper.signIn()
            try await AuthenticationManager.shared.signUpWithGoogle(tokens: tokens)
            submittedEmail = (Auth.auth().currentUser?.email)!

            if !validEmail {
                triggerRestart()
                throw EmailError.noMatch
            } else {
                do {
                    let existingProfile: Bool = try await checkProfile(email: submittedEmail)
                    if existingProfile {
                        throw EmailError.existingUser
                    }
                } catch {
                    await handleError(error: error, message: "An account has already been created with these authentication credentials. Please use the login option instead.")
                }
                emailSignInSuccess = true
            }
        } catch {
            await handleError(error: error, message: "An error occurred trying to sign up with the email you provided. Please re-verify your phone number & try to create your account again.")
            triggerRestart()
        }
    }

    // MARK: - Handling errors

    func handleError(error: Error, message: String?) async {
        await MainActor.run(body: {
            if message != nil {
                errorMessage = message!
            } else {
                errorMessage = error.localizedDescription
            }
            showError.toggle()
        })
    }

    func checkProfile(email: String) async throws -> Bool {
        guard let userID = Auth.auth().currentUser?.uid else {
            return false
        }
        let profileRef = profileParser(school: schoolParser(email: email))
        guard let document = try await profileRef?.document(userID).getDocument() else {
            throw EmailError.noExistingUser
        }
        return document.exists
    }

    func triggerRestart() {
        print("Triggered restart.")
        validUser = false
        validPhoneNumberString = false
        validPhoneNumber = false
        validVerificationCodeLength = false
        validVerificationCode = false
        validEmailString = false
        validEmail = false
        validName = false
        emailSignInSuccess = false
        validUsername = false
        login = false
        createAccount = false
        isMainAppPresented = false
    }

    func resetRestart() {
        restart = false
    }
}

// MARK: - Create user function

extension AuthModel {
    func presentMainApp() {
        if Auth.auth().currentUser?.email == nil || Auth.auth().currentUser?.phoneNumber == nil {
            return
        } else {
            isMainAppPresented = true
        }
    }

    func createProfile() {
        userID = Auth.auth().currentUser!.uid
        email = Auth.auth().currentUser?.email ?? email
        phoneNumber = Auth.auth().currentUser?.phoneNumber ?? "+1\(phoneNumber)"

        let school: String = schoolParser(email: email)
        let nameInsensitive: String = name.lowercased()

        var userRef: CollectionReference
        var profileRef: CollectionReference

        if school == "nd" {
            userRef = ndUsers
            profileRef = ndProfiles
        } else if school == "yale" {
            userRef = yaleUsers
            profileRef = yaleProfiles
        } else if school == "rice" {
            userRef = riceUsers
            profileRef = riceProfiles
        } else {
            return
        }
        var profileData: [String: Any]
        var userData: [String: Any]

        do {
            profileData = try Firestore.Encoder().encode(Profile(name: name, nameInsensitive: nameInsensitive, phoneNumber: phoneNumber, email: email, username: username, posts: [], smores: 0, profilePicURL: profilePic, userID: userID, school: school, bio: ""))
            userData = try Firestore.Encoder().encode(PrivateUser(phoneNumber: phoneNumber, email: email, userID: userID, school: school))
        } catch {
            print("Could not encode requestFields.")
            return
        }

        // based on the user's school, their profile document is sorted into the appropriate school document

        profileRef.document(userID).setData(profileData)
        userRef.document(userID).setData(userData)
        print("Documents successfully written!")
    }

    func getProfile() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            let school: String = schoolParser(email: (Auth.auth().currentUser?.email)!)
            guard let profileRef: CollectionReference = profileParser(school: school) else {
                return
            }
            let userID = Auth.auth().currentUser!.uid
            profileRef.document(userID).getDocument(as: Profile.self) { [self] result in
                switch result {
                case let .success(profileData):
                    self.profile = profileData
                    print("Profile Email: \(self.profile.email)")
                case let .failure(error):
                    print("Error decoding profile: \(error)")
                }
            }
        }
    }
}

// MARK: - Extension to UIApplication for setup of closeKeyboard function

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
