//
//  CamPostModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/1/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class CamPostModel: ObservableObject {
    
    @Published var caption: String  = ""
    let docRef = ndPosts.document()
    
    
    func createPost(data: [String: Any]) {    // This function creates the document and it passes in the variables set the field data
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
            "caption": caption,    //pass captiontextfield text into here
            "profilepic": "", // some path to the user's profile pic
            "url": photoURL,
            "numLikes": 0,
            "location": "",  //some string creation of location
            "comments": [""],
            "postType": "image",
            "id": docRef.documentID
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
        
        let videoDocData: [String: Any] = [
            "username": "davooo",
            "name": "David Adebogun",
            "caption": "yoo",    //pass captiontextfield text into here
            "profilepic": "", // some path to the user's profile pic
            "url": downloadedvidURL,
            "numLikes": 0,
            "location": "",  //some string creation of location
            "comments": [""],
            "postType": "video",
            "id": docRef.documentID
        ]
        self.createPost(data: videoDocData)
    }
}
