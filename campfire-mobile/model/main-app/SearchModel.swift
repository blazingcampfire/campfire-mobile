//
//  SearchPageView.swift
//  campfire-mobile
//
//  Created by Toni on 7/19/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class SearchModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var profiles: [Profile] = []
    @Published var requests: [RequestFirestore] = []
    @Published var name: String = "" {
        didSet {
            searchName(matching: name)
        }
    }
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        self.searchName(matching: name)
    }
    
    func searchName(matching: String) {
        // name is lowercased to make it case insensitive
        let name = name.lowercased()
        if name == "" {
            currentUser.profileRef.order(by: "smores", descending: true).limit(to: 10).getDocuments { QuerySnapshot, err in
                if let err = err {
                    print("Error querying profiles: \(err)")
                } else {
                    self.profiles = []
                    for document in QuerySnapshot!.documents {
                        do {
                            let profile = try document.data(as: Profile.self)
                            self.profiles.append(profile)
                        } catch {
                            print("Error retrieving profile")
                        }
                    }
                }
            }
        }
        currentUser.profileRef.order(by: "nameInsensitive").start(at: [name]).end(at: [name + "\u{f8ff}"]).limit(to: 8).getDocuments { QuerySnapshot, err in
            if let err = err {
                print("Error querying profiles: \(err)")
            } else {
                self.profiles = []
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
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
        }
        catch {
            print("Could not encode requestFields.")
            return
        }
        
        print(friendRelationshipRef.documentID)
        friendRelationshipRef.setData([
            "ownRequests": FieldValue.arrayUnion([userRequestField])
        ], merge: true)
    
        userRelationshipRef.setData([
            "sentRequests": FieldValue.arrayUnion([friendRequestField])
        ], merge: true)
    }
    
    func unrequestFriend(request: RequestFirestore) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        let friendID = request.userID
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        
        friendRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([Request(name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL)])
        ])
        
        userRelationshipRef.updateData([
            "sentRequests": FieldValue.arrayRemove([Request(name: request.name, username: request.username, profilePicURL: request.profilePicURL)])
        ])
    }
    
    func checkRequested(request: RequestFirestore) async -> Bool {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return false
        }
        do {
            guard let document = try await currentUser.relationshipsRef.document(self.currentUser.privateUserData.userID).getDocument().data() else { return false}
            print(document)
            let docField: [[String: Any]] = document["ownRequests"] as! [[String : Any]]
            for doc in docField {
                let requestData = RequestFirestore(data: doc)
                if requestData?.userID == request.userID {
                    print("Should be true")
                    return true
                }
            }
            }
        catch {
            print(error)
            return false
        }
        return false
        
    }
    
}
