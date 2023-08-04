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
    
    func uploadPhotoToStorage(imageData: Data) async throws -> String? {
        let storageRef = Storage.storage().reference()
        let path = "feedimages/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        do {
            let _ = try await fileRef.putDataAsync(imageData)
            let photoURL = try await fileRef.downloadURL()
            return photoURL.absoluteString
        } catch {
            print("Error upload photo to storage: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func createPhotoPost(imageData: Data) async throws {
        guard let photoURL = try await uploadPhotoToStorage(imageData: imageData) else { return }
        
        let photoDocData: [String: Any] = [
            "username": "davooo",
            "name": "David Adebogun",
            "caption": "yoo",    //pass captiontextfield text into here
            "profilepic": "", // some path to the user's profile pic
            "url": photoURL,
            "numLikes": 0,
            "location": "",  //some string creation of location
            "comments": [""],
            "postType": "image"
    
        ]
        self.createPost(data: photoDocData)
    }
    
    
    
    func uploadVideoToStorage(videoURL: URL) async throws -> String? {
        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("couldnt create video data")
            return nil
        }
        let storageRef = Storage.storage().reference()
        let fileName = videoURL.lastPathComponent
        let path = "feedvideos/\(fileName)"
        let videoRef = storageRef.child(path)
        
        do {
            let _ = try await videoRef.putDataAsync(videoData)
            let vidURL = try await videoRef.downloadURL()
            return vidURL.absoluteString
        } catch {
            print("Error upload photo to storage: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createVideoPost(videoURL: URL) async throws {
        guard let downloadedvidURL = try await uploadVideoToStorage(videoURL: videoURL) else{return}
        
//        let videoDocData: PostItem = PostItem(id: <#T##String#>, username: <#T##String#>, name: <#T##String#>, caption: <#T##String#>, profilepic: <#T##String#>, url: <#T##String#>, numLikes: <#T##Int#>, location: <#T##String#>, comments: <#T##[String]#>, postType: <#T##String#>)
        
        let videoDocData: [String: Any] = [
            "username": "davooo",
            "name": "David Adebogun",
            "caption": "yoo",    //pass captiontextfield text into here
            "profilepic": "", // some path to the user's profile pic
            "url": downloadedvidURL,
            "numLikes": 0,
            "location": "",  //some string creation of location
            "comments": [""],
            "postType": "video"
        ]
        self.createPost(data: videoDocData)
    }
    
    
    
    
    
    
    
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
