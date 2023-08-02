//
//  FriendsModel.swift
//  campfire-mobile
//
//  Created by Toni on 8/2/23.
//

import Foundation

class FriendsModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var currentUser: CurrentUserModel
    var userIDs: [String] = []
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func readFriends() -> Void {
        let userRelationships = ndRelationships.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            guard let snapshot = documentSnapshot?.get("friends") else {
                print("error fetching document: \(String(describing: error))")
                return
            }
            print(snapshot)
            self.userIDs = snapshot as! [String]
        }
    }
}

