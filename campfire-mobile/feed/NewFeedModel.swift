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

enum Assortment {
    case hot
    case new
}

class NewFeedModel: ObservableObject {
    @Published var posts = [PostItem]()
    @Published var updatedPostIndex: Int?
    @Published var newPostAdded: PostItem?
    @Published var currentAssortment: Assortment = .new
    var initialPostsLoaded = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    private var newListener: ListenerRegistration?
    private var hotListener: ListenerRegistration?
    
    init() {
        $currentAssortment
        .sink { [weak self] assortment in
            switch assortment {
            case .hot:
                self?.listenForHotPosts()
            case .new:
                self?.listenForNewPosts()
            }
        }.store(in: &cancellables)
    }
    
    deinit {
        newListener?.remove()
        hotListener?.remove()
    }

    func listenForNewPosts() {
        hotListener?.remove()
        newListener = ndPosts.order(by: "date", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    let newPost = self.getPostItem(from: data)
                    self.newPostAdded = newPost
                }
                else if (diff.type == .modified) {
                    let data = diff.document.data()
                    let newPost = self.getPostItem(from: data)
                    
                    if let index = self.posts.firstIndex(where: { $0.id == newPost.id }) {
                        self.posts[index] = newPost
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
    
    func listenForHotPosts() {
        newListener?.remove()
        hotListener = ndPosts.order(by: "score", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    let newPost = self.getPostItem(from: data)
                    self.newPostAdded = newPost
                }
                else if (diff.type == .modified) {
                    let data = diff.document.data()
                    let newPost = self.getPostItem(from: data)
                    
                    if let index = self.posts.firstIndex(where: { $0.id == newPost.id }) {
                        self.posts[index] = newPost
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
        let comNum = data["comNum"] as? Int ?? 0
        let score = data["score"] as? Int ?? 0

        // Now return a `PostItem` made from the above data
        return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes, comNum: comNum, score: score)
    }
    
    func fetchInitialPosts() {
        ndPosts.getDocuments { (querySnapshot, error) in
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


