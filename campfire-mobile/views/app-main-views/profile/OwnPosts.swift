//
//  OwnPosts.swift
//  Campfire
//
//  Created by Femi Adebogun on 9/5/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

class ProfileFeedPosts: ObservableObject {
    
    @Published var profilePosts = [PostItem]()
    @Published var userID: String
    @Published var currentUser: CurrentUserModel
    
    init(userID: String, currentUser: CurrentUserModel) {
        self.userID = userID
        self.currentUser = currentUser
        loadProfilePosts()
    }
    
    func loadProfilePosts() {
        let docRef = currentUser.postsRef.order(by: "date", descending: true).whereField("posterId", isEqualTo: userID)
        docRef.getDocuments { [weak self] querySnapshot, _ in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                return
            }
            var newPosts: [PostItem] = []
            snapshot.documents.forEach { document in
                let data = document.data()
                let newPost = self.getPostItem(from: data)
                newPosts.append(newPost)
            }
            self.profilePosts = newPosts
        }
    }
    
    
    func getPostItem(from data: [String: Any]) -> PostItem {
        let id = data["id"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let caption = data["caption"] as? String ?? ""
        let profilepic = data["profilepic"] as? String ?? ""
        let url = data["url"] as? String ?? ""
        let location = data["location"] as? String ?? ""
        let postType = data["postType"] as? String ?? ""
        let date = data["date"] as? Timestamp ?? Timestamp()
        let posterId = data["posterId"] as? String ?? ""
        let numLikes = data["numLikes"] as? Int ?? 0
        let comNum = data["comNum"] as? Int ?? 0
        let score = data["score"] as? Int ?? 0
        let usersWhoLiked = data["usersWhoLiked"] as? [String] ?? [""]
        return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes, comNum: comNum, score: score, usersWhoLiked: usersWhoLiked)
    }
    
    
}
