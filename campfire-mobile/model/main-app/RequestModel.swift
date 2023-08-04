//
//  RequestsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/30/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class RequestsModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var requests: [RequestFirestore]
    
    init(currentUser: CurrentUserModel, requests: [RequestFirestore]) {
        self.currentUser = currentUser
        self.requests = requests
    }
    
    func readRequests() -> Void {
        let userRelationships = ndRelationships.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let documentSnapshot = documentSnapshot {
                    print("Request Data got")
                    let reqs = documentSnapshot.get("ownRequests") as? [[String: Any]] ?? []
                    for req in reqs {
                        guard let n = RequestFirestore(data: req) else {
                            continue
                        }
                        print(n)
                    }
                }
            }
            
        }
    }
}
