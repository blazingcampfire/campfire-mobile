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
    @Published var showInitialMessage = false
    @Published var privateUserData: PrivateUser
    @Published var profile: Profile
    @Published var signedIn: Bool = false

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
        self.authStateDidChange()
    }
    
    func authStateDidChange() {
        Auth.auth().addStateDidChangeListener { _, user in
            if ((user?.email) != nil) && ((user?.phoneNumber) != nil) {
                self.signedIn = true
                // User is signed in. Show home screen
            } else {
                self.signedIn = false
                // No User is signed in. Show user the login screen
            }
        }
    }
        
    func checkProfile(email: String) async throws -> Bool {
            guard let userID = Auth.auth().currentUser?.uid else {
                return false
            }
            let profileRef = profileParser(school: schoolParser(email: email))
            guard let document = try await profileRef?.document(userID).getDocument() else {
                return false
            }
            return document.exists
        }
        
    
    func setCollectionRefs() {
        if Auth.auth().currentUser?.email == nil {
            return
        } else {
            let school: String = schoolParser(email: (Auth.auth().currentUser?.email)!)
            if school == "Does not belong to a supported school" {
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
                    return
                }
                
                guard let document = documentSnapshot, document.exists else {
                    return
                }
                
                guard let profile = try? document.data(as: Profile.self) else {
                    do {
                        try AuthenticationManager.shared.signOut()
                    }
                    catch {
                        return
                    }
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
                case let .failure(error):
                    do {
                        try AuthenticationManager.shared.signOut()
                    }
                    catch {
                        
                    }
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
            }
            catch {
                return
            }
        }
    }
}


