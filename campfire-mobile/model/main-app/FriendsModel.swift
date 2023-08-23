//
//  FriendsModel.swift
//  campfire-mobile
//
//  Created by Toni on 8/2/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class FriendsModel: ObservableObject {
    @Published var friends: [RequestFirestore] = []
    @Published var currentUser: CurrentUserModel

    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        readFriends()
    }

    func readFriends() {
        let userRelationships = currentUser.relationshipsRef.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            } else {
                if let documentSnapshot = documentSnapshot {
                    var friendsArray: [RequestFirestore] = []
                    let requests = documentSnapshot.get("friends") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        friendsArray.append(requestObject)
                    }
                    self.friends = friendsArray
                }
            }
        }
    }

    func readOtherFriends(userID: String) {
        let userRelationships = currentUser.relationshipsRef.document(userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            } else {
                if let documentSnapshot = documentSnapshot {
                    var friendsArray: [RequestFirestore] = []
                    let requests = documentSnapshot.get("friends") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        friendsArray.append(requestObject)
                    }
                    self.friends = friendsArray
                }
            }
        }
    }

    func removeFriend(request: RequestFirestore) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let friendID = request.userID
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        var friendRequestField: [String: Any]
        var userRequestField: [String: Any]

        do {
            friendRequestField = try Firestore.Encoder().encode(Request(userID: friendID, name: request.name, username: request.username, profilePicURL: request.profilePicURL))
            userRequestField = try Firestore.Encoder().encode(Request(userID: userID, name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL))
        } catch {
            return
        }
        friendRelationshipRef.updateData([
            "friends": FieldValue.arrayRemove([userRequestField]),
        ])

        userRelationshipRef.updateData([
            "friends": FieldValue.arrayRemove([friendRequestField]),
        ])
    }
}
