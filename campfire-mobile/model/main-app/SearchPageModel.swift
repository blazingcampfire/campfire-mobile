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
            search(matching: username)
        }
    }
    
    func search(matching: String) {
        ndProfiles.whereField("username", isGreaterThan: username).whereField("username", isLessThan: username+"\u{F7FF}").limit(to: 8).getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error querying profiles: \(err)")
            }
            else {
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
                        self.profiles.append(profile)
                    } catch {
                        print("\(document.documentID) => \(document.data())")
                    }
                    print("\(document.documentID) => \(document.data())")
                    print(self.profiles)
                }
            }
        }
        
        
    }
}
