//
//  FeedPostModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/28/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class FeedPostModel: ObservableObject {
    
    @Published var posts = [PostItem]()
    
    func getPosts() {
       let docRef = ndPosts
        docRef.getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.posts = snapshot.documents.map { doc in
                            return PostItem(id: doc["id"] as? String ?? "", username: doc["username"] as? String ?? "", name: doc["name"] as? String ?? "", caption: doc["caption"] as? String ?? "", profilepic: doc["profilepic"] as? String ?? "", url: doc["url"] as? String ?? "", numLikes: doc["numLikes"] as? Int ?? 0, location: doc["location"] as? String ?? "", comments: doc["comments"] as? [String] ?? [""], postType: doc["postType"] as? String ?? "" )
                        }
                        print("success")
                    }
                }
            }
        }
    }
    
    
}
