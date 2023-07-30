//
//  RequestsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/30/23.
//

import Foundation

class RequestsPageModel: ObservableObject {
    @Published var profiles: [Profile] = []
    var id: String
    
    init(profiles: [Profile], id: String) {
        self.profiles = profiles
        self.id = id
    }
    
    func readRequests() -> Void {
        let userRelationships = ndRelationships.document(id)
        
        userRelationships.getDocument { (document, error) in
            if let document = document, document.exists {
                let requests = document.data()
                print(requests)
                return
            }
            else {
                print("Document does not exist")
                return
            }
        }
    }
}
