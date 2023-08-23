//
//  LeaderboardModel.swift
//  campfire-mobile
//
//  Created by Toni on 8/5/23.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class LeaderboardModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var profiles: [Profile] = []

    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        getTop10()
    }

    func getTop10() {
        currentUser.profileRef.order(by: "smores", descending: true).limit(to: 10).addSnapshotListener { QuerySnapshot, err in
            if let err = err {
                return
            } else {
                self.profiles = []
                for document in QuerySnapshot!.documents {
                    do {
                        let profile = try document.data(as: Profile.self)
                        self.profiles.append(profile)
                    } catch {
                        return
                    }
                }
            }
        }
    }
}
