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
    
    
}
