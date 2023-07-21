//
//  SearchPageView.swift
//  campfire-mobile
//
//  Created by Toni on 7/19/23.
//

import Foundation
import Firebase

class SearchPageModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var username: String = ""
    
    func fetchProfiles(username: String) {
        
        
    }
}
