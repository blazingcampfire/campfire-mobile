//
//  RequestsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/30/23.
//

import Foundation

class RequestsPageModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var currentUser: CurrentUserModel
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func readRequests() -> Void {
        let userRelationships = ndRelationships.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            guard let snapshot = documentSnapshot else {
                print("error fetching document: \(error!)")
                return
            }
            print(snapshot.documentID)
        }
    }
}
