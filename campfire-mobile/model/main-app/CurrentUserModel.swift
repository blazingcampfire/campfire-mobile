//
//  CurrentUserModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/31/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

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
        }
        else {
            let school: String = schoolParser(email:(Auth.auth().currentUser?.email)!)
            guard let profileRef: CollectionReference = profileParser(school: school) else {
                return
            }
            guard let userRef: CollectionReference = userParser(school: school) else {
                return
            }
            let userID = Auth.auth().currentUser!.uid
            profileRef.document(userID).getDocument(as: Profile.self) { [self] result in
                switch result {
                case .success(let profileData):
                    self.profile = profileData
                    print("Profile Email: \(self.profile.email)")
                case .failure(let error):
                    print("Error decoding city: \(error)")
                }
                }
//            userRef.document(userID).getDocument(as: PrivateUser.self) { [self] result in
//                switch result {
//                case .success(let user):
//                    privateUserData = user
//                    print("Profile Email: \(privateUserData.email)")
//                case .failure(let error):
//                    print("Error decoding city: \(error)")
//                }
//                }
        }
    }
}
