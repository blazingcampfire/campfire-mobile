//
//  NewFeedModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/13/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUIPager
import Combine

class NewFeedModel: ObservableObject {
    @Published var posts = [PostItem]()
    @Published var updatedPostIndex: Int?
    var initialPostsLoaded = PassthroughSubject<Void, Never>()
    private var listener: ListenerRegistration?
    
    
    deinit {
        listener?.remove()
    }

    func listenForPosts() {
        print("listener went off")
        listener = ndPosts.order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    let newPost = self.getPostItem(from: data)
                    self.posts.append(newPost)
                }
                else if (diff.type == .modified) {
                    let data = diff.document.data()
                    let newPost = self.getPostItem(from: data)
                    
                    if let index = self.posts.firstIndex(where: { $0.id == newPost.id }) {
                        self.posts[index] = newPost
                        self.updatedPostIndex = index
                    }
                }
                else if (diff.type == .removed) {
                    let data = diff.document.data()
                    let removedPost = self.getPostItem(from: data)
                    
                    if let index = self.posts.firstIndex(where: { $0.id == removedPost.id }) {
                        self.posts.remove(at: index)
                    }
                }
            }
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

        // Now return a `PostItem` made from the above data
        return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes)
    }
    
    func fetchInitialPosts() {
        ndPosts.order(by: "date", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching initial posts: \(error)")
                return
            }

            print("fetched the posts")
            print("Raw Query Snapshot Data: \(String(describing: querySnapshot))")

            self.posts = querySnapshot?.documents.compactMap { document in
                let postItem = self.getPostItem(from: document.data())
                print("Parsed Post Item: \(postItem)")
                self.initialPostsLoaded.send(())
                return postItem
            } ?? []

            print("Updated Posts Array: \(self.posts)")
        }
    }


    
    
}


