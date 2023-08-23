//
//  NewFeedModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/13/23.
//

import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import SwiftUIPager

enum Assortment {
    case hot
    case new
}

class NewFeedModel: ObservableObject {
    @Published var posts = [PostItem]()
    @Published var currentAssortment: Assortment = .hot
    @Published var pauseVideos = false
    @Published var currentUser: CurrentUserModel
    var initialLoadCompleted = false
    var cancellables = Set<AnyCancellable>()

    private var newListener: ListenerRegistration?
    private var hotListener: ListenerRegistration?

    var lastDocumentSnapshot: DocumentSnapshot?
    var reachedEndofData = false

    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        $currentAssortment
            .sink { [weak self] assortment in
                self?.switchAssortment(to: assortment)
            }.store(in: &cancellables)
    }

    deinit {
        newListener?.remove()
        hotListener?.remove()
    }

    private func removeOldListeners(completion: @escaping () -> Void) {
        newListener?.remove()
        hotListener?.remove()
        completion()
    }

    private func startListener(for assortment: Assortment) {
        switch assortment {
        case .new:
            listenForNewPosts()
        case .hot:
            listenForHotPosts()
        }
    }

    private func switchAssortment(to assortment: Assortment) {
        posts.removeAll()
        removeOldListeners {
            self.loadInitialPosts {
                self.lastDocumentSnapshot = nil
                self.startListener(for: assortment)
            }
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    func listenForNewPosts() {
        hotListener?.remove()
        initialLoadCompleted = false

        newListener = currentUser.postsRef.order(by: "date", descending: true).limit(to: 3)
            .addSnapshotListener { [weak self] querySnapshot, _ in
                guard let self = self else { return }
                guard let snapshot = querySnapshot else {
                    return
                }
                // Initial Load
                if !self.initialLoadCompleted {
                    self.initialLoadCompleted = true

                    var newPosts: [PostItem] = []
                    snapshot.documents.forEach { document in
                        let data = document.data()
                        let newPost = self.getPostItem(from: data)
                        newPosts.append(newPost)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.posts = newPosts
                    }
                } else { // Subsequent updates
                    snapshot.documentChanges.forEach { diff in
                        let data = diff.document.data()
                        let post = self.getPostItem(from: data)

                        switch diff.type {
                        case .added:
                            self.posts.append(post)

                        case .modified: break

                        case .removed:
                            if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                                self.posts.remove(at: index)
                            }
                        }
                    }
                }
            }
    }

    func loadInitialPosts(completion: @escaping () -> Void) {
        reachedEndofData = false
        initialLoadCompleted = false
        posts.removeAll()

        var query: Query
        switch currentAssortment {
        case .hot:
            query = currentUser.postsRef.order(by: "score", descending: true).limit(to: 3)
        case .new:
            query = currentUser.postsRef.order(by: "date", descending: true).limit(to: 3)
        }

        query.getDocuments { [weak self] querySnapshot, _ in
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
            self.posts = newPosts
            self.lastDocumentSnapshot = snapshot.documents.last
            self.reachedEndofData = snapshot.documents.isEmpty || snapshot.documents.count < 3
            completion()
        }
    }

    func loadMorePosts() {
        guard !reachedEndofData else {
            return
        }
        var query: Query
        switch currentAssortment {
        case .hot:
            query = currentUser.postsRef.order(by: "score", descending: true).limit(to: 3)
        case .new:
            query = currentUser.postsRef.order(by: "date", descending: true).limit(to: 3)
        }

        if let lastSnapshot = lastDocumentSnapshot {
            // Start after the last document we have
            query = query.start(afterDocument: lastSnapshot)
        }

        query.getDocuments { [weak self] querySnapshot, _ in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                return
            }

            var newPosts: [PostItem] = []
            snapshot.documents.forEach { document in
                let data = document.data()
                let post = self.getPostItem(from: data)
                newPosts.append(post)
            }

            let newUniquePosts = newPosts.filter { newItem in
                !self.posts.contains(where: { $0.id == newItem.id })
            }

            // Append the new posts to the existing posts
            DispatchQueue.main.async {
                self.posts.append(contentsOf: newUniquePosts)
                self.objectWillChange.send()
            }
            self.lastDocumentSnapshot = snapshot.documents.last
            self.reachedEndofData = snapshot.documents.isEmpty || snapshot.documents.count < 3
        }
    }

    func listenForHotPosts() {
        newListener?.remove()
        initialLoadCompleted = false

        hotListener = currentUser.postsRef.order(by: "score", descending: true).limit(to: 3)
            .addSnapshotListener { [weak self] querySnapshot, _ in

                guard let self = self else { return }
                guard let snapshot = querySnapshot else {
                    return
                }

                // Initial Load
                if !self.initialLoadCompleted {
                    self.initialLoadCompleted = true

                    var newPosts: [PostItem] = []
                    snapshot.documents.forEach { document in
                        let data = document.data()
                        let newPost = self.getPostItem(from: data)
                        newPosts.append(newPost)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.posts = newPosts
                    }
                } else { // Subsequent updates
                    snapshot.documentChanges.forEach { diff in
                        let data = diff.document.data()
                        let post = self.getPostItem(from: data)

                        switch diff.type {
                        case .added:
                            self.posts.append(post)

                        case .modified: break

                        case .removed:
                            if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                                self.posts.remove(at: index)
                            }
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
        let usersWhoLiked = data["usersWhoLiked"] as? [String] ?? [""]
        return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes, comNum: comNum, score: score, usersWhoLiked: usersWhoLiked)
    }
}
