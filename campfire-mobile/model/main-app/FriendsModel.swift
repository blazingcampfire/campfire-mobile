//
//  FriendsModel.swift
//  campfire-mobile
//
//  Created by Toni on 8/2/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FriendsModel: ObservableObject {
    @Published var friends: [RequestFirestore] = []
    @Published var currentUser: CurrentUserModel
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        self.readFriends()
    }
    
    func readFriends() {
        let userRelationships = currentUser.relationshipsRef.document(self.currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let documentSnapshot = documentSnapshot {
                    var friendsArray: [RequestFirestore] = []
                    let requests = documentSnapshot.get("friends") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        print(requestObject)
                        friendsArray.append(requestObject)
                    }
                    self.friends = friendsArray
                }
            }
            
        }
    }
    
    func removeFriend(request: RequestFirestore) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        guard let friendID = request.userID else {
            return
        }
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        var friendRequestField: [String: Any]
        var userRequestField: [String: Any]
        
        do {
            friendRequestField = try Firestore.Encoder().encode(Request(userID: friendID, name: request.name, username: request.username, profilePicURL: request.profilePicURL))
            userRequestField = try Firestore.Encoder().encode(Request(userID: userID, name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL))
        }
        catch {
            print("Could not encode requestFields.")
            return
        }
        friendRelationshipRef.updateData([
            "friends": FieldValue.arrayRemove([userRequestField])
        ])
        
        userRelationshipRef.updateData([
            "friends": FieldValue.arrayRemove([friendRequestField])
        ])
    }
}

