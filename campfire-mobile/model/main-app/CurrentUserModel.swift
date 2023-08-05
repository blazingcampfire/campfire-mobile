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
    var userRef: CollectionReference
    var profileRef: CollectionReference
    var relationshipsRef: CollectionReference
    var postsRef: CollectionReference

    init(privateUserData: PrivateUser, profile: Profile, userRef: CollectionReference, profileRef: CollectionReference, relationshipsRef: CollectionReference, postsRef: CollectionReference) {
        self.privateUserData = privateUserData
        self.profile = profile
        self.userRef = userRef
        self.profileRef = profileRef
        self.relationshipsRef = relationshipsRef
        self.postsRef = postsRef
    }

    func setCollectionRefs() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            let school: String = schoolParser(email: (Auth.auth().currentUser?.email)!)
            if school == "Does not belong to a supported school" {
                print("Sorry, but we do not currently support your school.")
                return
            }
            userRef = userParser(school: school)!
            profileRef = profileParser(school: school)!
            relationshipsRef = relationshipsParser(school: school)!
            postsRef = postsParser(school: school)!
        }
    }

    func getProfile() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            let docRef = profileRef.document(userID)
            docRef.addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }
                
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist or there was an error.")
                    return
                }
                
                guard let profile = try? document.data(as: Profile.self) else {
                    print("Error decoding profile in profileModel.")
                    return
                }
                
                let postPaths = profile.posts
                
                if postPaths.isEmpty {
                    DispatchQueue.main.async {
                        self.profile = profile
                    }
                } else {
                    for path in postPaths {
                        if let (imageData, prompt) = path.first {
                            DispatchQueue.main.async {
                                self.profile = profile
                            }
                        }
                    }
                }
            }

        }
    }

    func getUser() {
        if Auth.auth().currentUser?.uid == nil {
            return
        } else {
            let userID = Auth.auth().currentUser!.uid
            userRef.document(userID).getDocument(as: PrivateUser.self) { [self] result in
                switch result {
                case let .success(user):
                    self.privateUserData = user
                    print("Profile Email: \(privateUserData.email)")
                case let .failure(error):
                    print("Error decoding profile: \(error)")
                }
            }
        }
    }
    
    func makeTestProfiles(testProfiles: [Profile]) {
        for testProfile in testProfiles {
           let testUser = PrivateUser(phoneNumber: testProfile.phoneNumber, email: testProfile.email, userID: testProfile.userID, school: testProfile.school)
            do {
                try ndProfiles.document("\(testProfile.userID)").setData(from: testProfile)
                try ndUsers.document("\(testProfile.userID)").setData(from: testUser)
                print("Documents successfully written!")
            } catch {
                print("Error writing profile or user to firestore \(error)")
            }
        }
    }
}
