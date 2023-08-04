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
    @Published var currentUser: CurrentUserModel
    @Published var profiles: [Profile] = []
    @Published var name: String = "" {
        didSet {
            self.profiles = []
            searchName(matching: name)
            print("Email: \(self.currentUser.profile.email). Collection: \(self.currentUser.profileRef.path)")
        }
    }
    
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
    func requestFriend(profile: Profile) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        let friendID = profile.userID
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        var friendRequestField: [String: Any]
        var userRequestField: [String: Any]
        
        do {
            friendRequestField = try Firestore.Encoder().encode(Request(userID: friendID, name: profile.name, username: profile.username, profilePicURL: profile.profilePicURL))
            userRequestField = try Firestore.Encoder().encode(Request(userID: userID, name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL))
        }
        catch {
            print("Could not encode requestFields.")
            return
        }
        
        print(friendRelationshipRef.documentID)
        friendRelationshipRef.setData([
            "sentRequests": FieldValue.arrayUnion([friendRequestField])
        ], merge: true)
    
        userRelationshipRef.setData([
            "ownRequests": FieldValue.arrayUnion([userRequestField])
        ], merge: true)
    }
    
    func unrequestFriend(request: RequestFirestore) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        guard let friendID = request.userID else {
            print("No request ID")
            return
        }
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        
        friendRelationshipRef.updateData([
            "sentRequests": FieldValue.arrayRemove([Request(name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL)])
        ])
        
        userRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([Request(name: request.name, username: request.username, profilePicURL: request.profilePicURL)])
        ])
    }
    
}
