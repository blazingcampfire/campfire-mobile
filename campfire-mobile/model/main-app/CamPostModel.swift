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
    @Published var currentUser: CurrentUserModel?
    @Published var caption: String  = ""
    
    let locationManager = LocationManager()
    
    
    func createPost(data: [String: Any], documentRef: DocumentReference) {    // This function creates the document and it passes in the variables set the field data
        documentRef.setData(data) { error in
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
        let docRef = ndPosts.document()
        let now = Timestamp(date: Date())
        locationManager.getLocation()
        locationManager.getAddress { location in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return }
                let photoDocData: [String: Any] = [
                    "username": "davooo",
                    "name": "David Adebogun",
                    "caption": caption,    //pass captiontextfield text into here
                    "profilepic": "", // some path to the user's profile pic
                    "url": photoURL,
                    "numLikes": 0,
                    "location": location ?? "",
                    "postType": "image",
                    "id": docRef.documentID,
                    "date": now
                ]
                self.createPost(data: photoDocData, documentRef: docRef)
                caption = ""
                print("\(location ?? "")")
            }
        }
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
        let docRef = ndPosts.document()
        let now = Timestamp(date: Date())
        locationManager.getLocation()
        locationManager.getAddress { location in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                let videoDocData: [String: Any] = [
                    "username": "davooo",
                    "name": "David Adebogun",
                    "caption": caption,    //pass captiontextfield text into here
                    "profilepic": "", // some path to the user's profile pic
                    "url": downloadedvidURL,
                    "numLikes": 0,
                    "location": location ?? "",
                    "postType": "video",
                    "id": docRef.documentID,
                    "date": now
                ]
                self.createPost(data: videoDocData, documentRef: docRef)
                caption = ""
                print("\(location ?? "")")
            }
        }
    }
}
