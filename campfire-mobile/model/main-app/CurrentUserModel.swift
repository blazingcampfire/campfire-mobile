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

    init(privateUserData: PrivateUser, profile: Profile) {
        self.privateUserData = privateUserData
        self.profile = profile
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

    func getUser() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            let school: String = schoolParser(email: (Auth.auth().currentUser?.email)!)
            guard let userRef: CollectionReference = userParser(school: school) else {
                return
            }
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
