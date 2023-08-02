//
//  SearchPageView.swift
//  campfire-mobile
//
//  Created by Toni on 7/19/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class SearchModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var name: String = "" {
        didSet {
            self.profiles = []
            searchName(matching: name)
            print("Email: \(self.currentUser.profile.email). Collection: \(self.currentUser.profileRef.path)")
        }
    }
    @Published var currentUser: CurrentUserModel
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func searchName(matching: String) {
        // name is lowercased to make it case insensitive
        let name = name.lowercased()
        if name == "" {
            return
        }
        currentUser.profileRef.order(by: "nameInsensitive").start(at: [name]).end(at: [name + "\u{f8ff}"]).limit(to: 8).getDocuments { QuerySnapshot, err in
            if let err = err {
                print("Error querying profiles: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
                        print(profile.name)
                        self.profiles.append(profile)
                    } catch {
                        print("Error retrieving profile")
                        print("\(document.documentID) => \(document.data())")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }

    // this function will create/update the document that represents the user -> <- friend relationship by showing that the user has requested to begin a friendship
    func requestFriend(friendID: String, profile: Profile) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        let friendRelationshipRef = ndRelationships.document(friendID)
        let userRelationshipRef = ndRelationships.document(userID)
        
        friendRelationshipRef.setData([
            "friendRequests": [currentUser.profile.userID: Request(name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL)]
        ], merge: true)
        print(friendRelationshipRef.documentID)
        userRelationshipRef.setData([
            "ownRequests": [ profile.userID: Request(name: profile.name, username: profile.username, profilePicURL: profile.profilePicURL)]
        ])
    }
    
    func unrequestFriend(friendID: String, profile: Profile) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        let friendRelationshipRef = ndRelationships.document(friendID)
        let userRelationshipRef = ndRelationships.document(userID)
        
        friendRelationshipRef.updateData([
            "friendRequests": FieldValue.arrayRemove([Request(name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL)])
        ])
        userRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([profile])
        ])
    }
    
}
