//
//  RequestsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/30/23.
//

import Foundation

class RequestsModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var currentUser: CurrentUserModel
    var userIDs: [String] = []
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func readRequests() -> Void {
        let userRelationships = ndRelationships.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            guard let snapshot = documentSnapshot?.get("ownRequests") else {
                print("error fetching document: \(String(describing: error))")
                return
            }
            print(snapshot)
            self.userIDs = snapshot as? [String] ?? []
            print(self.userIDs)
        }
    }
}
