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
    @Published var requested: [Bool] = []
    @Published var name: String = "" {
        didSet {
            searchName(matching: name)
        }
    }

    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }

    func searchName(matching: String) {
        // name is lowercased to make it case insensitive
        let name = name.lowercased()
        if name == "" {
            self.profiles = []
            self.requested = []
            return
        }
        currentUser.profileRef.order(by: "nameInsensitive").start(at: [name]).end(at: [name + "\u{f8ff}"]).limit(to: 8).getDocuments { QuerySnapshot, err in
            if let err = err {
                print("Error querying profiles: \(err)")
            } else {
                self.profiles = []
                self.requested = []
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
                        var requestData: [String: Any]
                        requestData = try Firestore.Encoder().encode(Request(userID: profile.userID, name: profile.name, username: profile.username, profilePicURL: profile.profilePicURL))
                        print(self.checkRequested(request: RequestFirestore(data: requestData)!))
                        print(self.requested)
                        self.profiles.append(profile)
                    } catch {
                        print("Error retrieving profile")
                    }
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
        } catch {
            print("Could not encode requestFields.")
            return
        }

        print(friendRelationshipRef.documentID)
        friendRelationshipRef.setData([
            "ownRequests": FieldValue.arrayUnion([userRequestField]),
        ], merge: true)

        userRelationshipRef.setData([
            "sentRequests": FieldValue.arrayUnion([friendRequestField]),
        ], merge: true)
    }

    func checkRequested(request: RequestFirestore) -> Bool {
        var requestBool: Bool = false
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return false
        }

        currentUser.relationshipsRef.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let documentSnapshot = documentSnapshot {
                    let requests = documentSnapshot.get("sentRequests") as? [[String: Any]] ?? []
                    for rawRequest in requests {
                        guard let neatRequest = RequestFirestore(data: rawRequest) else {
                            print("Error comparing requests")
                            return
                        }
                        if request.userID == neatRequest.userID {
                            requestBool = true
                            print(request.userID, neatRequest.userID)
                            print(requestBool)
                            return
                        }
                    }
                }
            }
        }
        return requestBool
    }
}
