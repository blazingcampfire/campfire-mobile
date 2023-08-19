//
//  RequestsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/30/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class RequestsModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var requests: [RequestFirestore] = []
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        self.readRequests()
    }
    
    func readRequests() {
        do {
            currentUser.relationshipsRef.document(self.currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if let documentSnapshot = documentSnapshot {
                        var requestsArray: [RequestFirestore] = []
                        let requests = documentSnapshot.get("ownRequests") as? [[String: Any]] ?? []
                        for request in requests {
                            guard let requestObject = RequestFirestore(data: request) else {
                                return
                            }
                            requestsArray.append(requestObject)
                        }
                        self.requests = requestsArray
                    }
                }
                
            }
        }
        catch {
            print(error)
        }
    }
        
    func removeRequest(request: RequestFirestore) {
        print("fired remove request")
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
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
        }
        catch {
            print("Could not encode requestFields.")
            return
        }
        friendRelationshipRef.updateData([
            "sentRequests": FieldValue.arrayRemove([userRequestField])
        ])
        
        userRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([friendRequestField])
        ])
    }
    func acceptFriend(request: RequestFirestore) {
        self.removeRequest(request: request)
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
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
        }
        catch {
            print("Could not encode requestFields.")
            return
        }
        print(friendRelationshipRef.documentID)
        friendRelationshipRef.setData([
            "friends": FieldValue.arrayUnion([userRequestField])
        ], merge: true)
    
        userRelationshipRef.setData([
            "friends": FieldValue.arrayUnion([friendRequestField])
        ], merge: true)
    }
}
