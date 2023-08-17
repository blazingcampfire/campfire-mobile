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
import Firebase

enum Assortment {
    case hot
    case new
}

class NewFeedModel: ObservableObject {
    @Published var posts = [PostItem]()
    @Published var currentAssortment: Assortment = .hot
    var initialLoadCompleted = false
    var cancellables = Set<AnyCancellable>()
    
    private var newListener: ListenerRegistration?
    private var hotListener: ListenerRegistration?
    
     var lastDocumentSnapshot: DocumentSnapshot?
     var reachedEndofData = false
    
    init() {
        $currentAssortment
        .sink { [weak self] assortment in
            self?.switchAssortment(to: assortment)
        }.store(in: &cancellables)
    }
    
    deinit {
        newListener?.remove()
        hotListener?.remove()
    }
    
    private func switchAssortment(to assortment: Assortment) {
        
        self.posts.removeAll()
        
        DispatchQueue.main.async {
              self.objectWillChange.send()
          }
        
        loadInitialPosts()
        
       }
    
    

    func listenForNewPosts() {
        hotListener?.remove()
        initialLoadCompleted = false
        
        newListener = ndPosts.order(by: "date", descending: false)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
            
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
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
                
                self.posts = newPosts
                
            } else {  // Subsequent updates
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    let post = self.getPostItem(from: data)
                    
                    switch diff.type {
                    case .added:
                        self.posts.append(post)
                        
                    case .modified:
                        print("updated post")
                        
                    case .removed:
                        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                            self.posts.remove(at: index)
                        }
                    }
                }
            }
        }
    }

    func loadInitialPosts() {
        self.reachedEndofData = false
        print("loaded three posts")
        
        let query: Query
        switch currentAssortment {
        case .hot:
            query = ndPosts.order(by: "score", descending: true).limit(to: 3)
        case .new:
            query = ndPosts.order(by: "date", descending: false).limit(to: 3)
        }
        
        query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                let data = diff.document.data()
                let post = self.getPostItem(from: data)
                
                switch diff.type {
                case .added:
                    // If the initial load hasn't been completed, append the posts.
                    // After initial load, only add new posts.
                //    if !self.initialLoadCompleted {
                        self.posts.append(post)
               //     }
                    
                case .modified:
                    // Update the specific post that was modified.
                    print("updated post")
                    
                case .removed:
                    // Remove the specific post that was deleted.
                    if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                        self.posts.remove(at: index)
                    }
                }
            }
            // After initial data is loaded, set initialLoadCompleted to true
            if !self.initialLoadCompleted {
                self.initialLoadCompleted = true
            }
            
            // Set the lastDocumentSnapshot for further pagination
            self.lastDocumentSnapshot = snapshot.documents.last
            // Check if we reached the end of data
            self.reachedEndofData = snapshot.documents.isEmpty || snapshot.documents.count < 3
        }
    }

    
    func loadMorePosts() {
        guard !reachedEndofData else {
            return
        }
        print("loaded three more posts")
        var query: Query
        switch currentAssortment {
        case .hot:
            query = ndPosts.order(by: "score", descending: true).limit(to: 3)
        case .new:
            query = ndPosts.order(by: "date", descending: false).limit(to: 3)
        }
        
        if let lastSnapshot = self.lastDocumentSnapshot {
            // Start after the last document we have
            query = query.start(afterDocument: lastSnapshot)
        }
        
        query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                let data = diff.document.data()
                let post = self.getPostItem(from: data)
                
                switch diff.type {
                case .added:
                    self.posts.append(post)
                    
                case .modified:
                    print("updated post")
                    
                case .removed:
                    if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                        self.posts.remove(at: index)
                    }
                }
            }
            // Set the lastDocumentSnapshot for further pagination
            self.lastDocumentSnapshot = snapshot.documents.last
            // Check if we reached the end of data
            self.reachedEndofData = snapshot.documents.isEmpty || snapshot.documents.count < 3
        }
    }


    

    
    func listenForHotPosts() {
        newListener?.remove()
        initialLoadCompleted = false
        
        hotListener = ndPosts.order(by: "score", descending: true)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
            
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
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
                
                self.posts = newPosts
                
            } else {  // Subsequent updates
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    let post = self.getPostItem(from: data)
                    
                    switch diff.type {
                    case .added:
                        self.posts.append(post)
                        
                    case .modified:
                        print("updated post")
                        
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
        return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes, comNum: comNum, score: score)
    }
    

    
    
}


