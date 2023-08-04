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
                print(error?.localizedDescription)
            } else {
                if let documentSnapshot = documentSnapshot {
                    print("Request Data got")
                    print(documentSnapshot.data())
                    let requests = documentSnapshot.get("friends") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        print(requestObject)
                        self.friends.append(requestObject)
                    }
                }
            }
            
        }
    }
}

