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
        let userRelationships = ndRelationships.document(id).addSnapshotListener { documentSnapshot, error in
            guard let collection = documentSnapshot else {
                print("error fetching document: \(error!)")
                return
            }
            print(collection)
        }
    }
}
