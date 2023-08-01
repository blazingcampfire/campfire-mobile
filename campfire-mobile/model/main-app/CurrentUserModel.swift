//
//  CurrentUserModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/31/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

class CurrentUserModel: ObservableObject {
    @Published var privateUserData: PrivateUser
    @Published var profile: Profile
    var profileRef: CollectionReference
    var userRef: CollectionReference

    init(privateUserData: PrivateUser, profile: Profile, profileRef: CollectionReference, userRef: CollectionReference) {
        self.privateUserData = privateUserData
        self.profile = profile
        self.profileRef = profileRef
        self.userRef = userRef
    }

    func getProfile() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            let school: String = schoolParser(email: (Auth.auth().currentUser?.email)!)
            guard let guardedProfileRef = profileParser(school: school) else {
                return
            }
            profileRef = guardedProfileRef
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

    func getUser() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            let school: String = schoolParser(email: (Auth.auth().currentUser?.email)!)
            guard let guardedUserRef: CollectionReference = userParser(school: school) else {
                return
            }
            userRef = guardedUserRef
            let userID = Auth.auth().currentUser!.uid
            userRef.document(userID).getDocument(as: PrivateUser.self) { [self] result in
                switch result {
                case let .success(user):
                    privateUserData = user
                    print("Profile Email: \(privateUserData.email)")
                case let .failure(error):
                    print("Error decoding profile: \(error)")
                }
            }
        }
    }
}
