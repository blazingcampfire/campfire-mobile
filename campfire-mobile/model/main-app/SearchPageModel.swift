//
//  SearchPageView.swift
//  campfire-mobile
//
//  Created by Toni on 7/19/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
class SearchPageModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var username: String = "" {
        didSet {
            self.profiles = []
            search(matching: username)
        }
    }
    
    func search(matching: String) {
        // username is lowercased to make it case insensitive
        let username = username.lowercased()
        if username == "" {
            return
        }
        ndProfiles.whereField("usernameInsensitive", isGreaterThan: username).whereField("usernameInsensitive", isLessThan: username+"\u{F7FF}").limit(to: 8).getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error querying profiles: \(err)")
            }
            else {
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
                        print(profile.username)
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
}
