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
    @Published var currentAssortment: Assortment = .hot
    private var initialLoadCompleted = false
    var cancellables = Set<AnyCancellable>()
    
    private var newListener: ListenerRegistration?
    private var hotListener: ListenerRegistration?
    
    
    
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
           // Step 1: Clear the current posts
        self.posts.removeAll()
        
        DispatchQueue.main.async {
              self.objectWillChange.send()
          }
         // Switch the assortment and start the appropriate listener
           switch assortment {
           case .hot:
               listenForHotPosts()
           case .new:
               listenForNewPosts()
           }
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


