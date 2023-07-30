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
class SearchPageModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var name: String = "" {
        didSet {
            searchName(matching: name)
        }
    }

    func searchName(matching: String) {
        // name is lowercased to make it case insensitive
        let name = name.lowercased()
        if name == "" {
            return
        }
        ndProfiles.whereField("nameInsensitive", isGreaterThan: name).whereField("nameInsensitive", isLessThan: name + "\u{F7FF}").limit(to: 8).getDocuments { QuerySnapshot, err in
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
    func requestFriend(friendID: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        let relationshipRef = ndRelationships.document(friendID)
        
        relationshipRef.collection("ownRequests").document(friendID).setData([
            "ownRequests": userID,
        ], merge: true)
        print(relationshipRef.documentID)
    }
    
    func unrequestFriend(friendID: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        let relationshipRef = ndRelationships.document(friendID)
        
//        relationshipRef.updateData([
//            "ownRequests": FieldValue.arrayRemove(userID)
//        ])
    }
    
}
