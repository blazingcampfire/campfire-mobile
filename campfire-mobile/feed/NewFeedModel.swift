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
           
           // Step 2 and 3: Switch the assortment and start the appropriate listener
           switch assortment {
           case .hot:
               listenForHotPosts()
           case .new:
               listenForNewPosts()
           }
       }
    
    

    func listenForNewPosts() {
        hotListener?.remove()
        newListener = ndPosts.order(by: "date", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            // Create a new array to store the updated list of posts
            var newPosts: [PostItem] = []
            // For each document in the snapshot, convert it to a PostItem and append it to newPosts
            snapshot.documents.forEach { document in
                let data = document.data()
                let newPost = self.getPostItem(from: data)
                newPosts.append(newPost)
            }
            self.posts = newPosts
        }
    }

    
    func listenForHotPosts() {
        newListener?.remove()
        hotListener = ndPosts.order(by: "score", descending: true) // Replace 'someProperty' with your actual field name
            .addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var newPosts: [PostItem] = []
            snapshot.documents.forEach { document in
                let data = document.data()
                let newPost = self.getPostItem(from: data)
                newPosts.append(newPost)
            }
            self.posts = newPosts
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


