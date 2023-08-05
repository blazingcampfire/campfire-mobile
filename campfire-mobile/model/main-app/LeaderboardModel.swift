//
//  LeaderboardModel.swift
//  campfire-mobile
//
//  Created by Toni on 8/5/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class LeaderboardModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var profiles: [Profile] = []
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        getTop10()
    }
    
    func getTop10() {
        currentUser.profileRef.order(by: "smores", descending: true).limit(to: 10).getDocuments { QuerySnapshot, err in
            if let err = err {
                print("Error querying profiles: \(err)")
            } else {
                self.profiles = []
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
                        print(profile.name)
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
