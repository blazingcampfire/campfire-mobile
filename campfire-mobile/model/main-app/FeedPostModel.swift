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
    
    func createPost(data: [String: Any]) {    // This function creates the document and it passes in the variables set the field data
        let docRef = ndPosts.document()
        docRef.setData(data) { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success creation")
            }
        }
    }
    
    func postPhoto(imageData: Data?) {
        let storageRef = Storage.storage().reference()
        let path = "feedimages/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let photoDocData: [String: Any] = [
            "username": "davooo",
            "name": "David Adebogun",
            "caption": "yoo",    //pass captiontextfield text into here
            "profilepic": "", // some path to the user's profile pic
            "url": path,
            "numLikes": 0,
            "location": "",  //some string creation of location
            "comments": [""],
            "postType": "image"
        ]
        
        guard imageData != nil else {
            return
        }
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                self.createPost(data: photoDocData)
            }
        }
    }
    
    func postVideo(videoURL: URL, completion: @escaping (Bool) -> Void) {
        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("couldnt create video data")
            return
        }
        let storageRef = Storage.storage().reference()
        let fileName = videoURL.lastPathComponent
        let path = "feedvideos/\(fileName)"
        let videoRef = storageRef.child(path)
       
        
        let videoDocData: [String: Any] = [
            "username": "davooo",
            "name": "David Adebogun",
            "caption": "yoo",    //pass captiontextfield text into here
            "profilepic": "", // some path to the user's profile pic
            "url": path,
            "numLikes": 0,
            "location": "",  //some string creation of location
            "comments": [""],
            "postType": "video"
        ]
        videoRef.putData(videoData) { metadata, error in
            guard let metadata = metadata, error == nil else {
                print("error upload to firebase")
                completion(false)
                return
            }
            self.createPost(data: videoDocData)
            print("upload successful")
            completion(true)
        }
    }
    
    func getPosts() {
       let docRef = ndPosts
        docRef.getDocuments { snapshot, error in

            if error == nil {

                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.posts = snapshot.documents.map { doc in
                            return PostItem(id: doc.documentID, username: doc["username"] as? String ?? "", name: doc["name"] as? String ?? "", caption: doc["caption"] as? String ?? "", profilepic: doc["profilepic"] as? String ?? "", url: doc["url"] as? String ?? "", numLikes: doc["numLikes"] as? Int ?? 0, location: doc["location"] as? String ?? "", comments: doc["comments"] as? [String] ?? [""], postType: doc["postType"] as? String ?? "" )
                        }
                        print("success")
                    }
                }
            }

        }
    }
    
    
}
