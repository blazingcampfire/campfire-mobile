//
//  RequestsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/30/23.
//

import Foundation

class RequestsPageModel: ObservableObject {
    @Published var profiles: [Profile] = []
    
    func readRequests(userID: String) {
        let userRelationships = ndRelationships.document(userID)
        
        userRelationships.getDocument { (document, error) in
            if let document = document, document.exists {
                let requests = document.data()
                print(requests)
            }
            else {
                print("Document does not exist")
                return
            }
        }
    }
}
