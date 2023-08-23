//
//  CamPostModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/1/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class CamPostModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var caption: String = ""

    let locationManager = LocationManager()

    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }

    func createPost(data: [String: Any], documentRef: DocumentReference) {
        // This function creates the document and it passes in the variables set the field data
        documentRef.setData(data) { error in
            if let error = error {
                return
            }
        }
    }

    // Edit this function to take in userId which passes currentUser.profile.id as a field on creation
    func createPhotoPost(imageData: Data) async throws {
        let imagePath = "feedpostimages/\(UUID().uuidString).jpg"
        uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { [self] photoURL in
            let docRef = currentUser.postsRef.document()
            let now = Timestamp(date: Date())
            self.locationManager.getLocation { [weak self] in
                self?.locationManager.getAddress { location in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let photoDocData: [String: Any] = [
                            "username": currentUser.profile.username,
                            "name": currentUser.profile.name,
                            "caption": self.caption, // Pass captiontextfield text into here
                            "profilepic": currentUser.profile.profilePicURL, // some path to the user's profile pic
                            "url": photoURL ?? "",
                            "location": location ?? "",
                            "postType": "image",
                            "id": docRef.documentID,
                            "date": now,
                            "posterId": currentUser.profile.userID, // id of the person who posted
                            "numLikes": 0,
                            "comNum": 0,
                            "score": 0,
                            "usersWhoLiked": [""],
                        ]
                        self.createPost(data: photoDocData, documentRef: docRef)
                        self.caption = ""
                    }
                }
            }
        }
    }

    func createVideoPost(videoURL: URL) async throws {
        let videoPath = "feedPostVideos/\(UUID().uuidString).mov"
        uploadVideoToBunnyStorage(videoURL: videoURL, videoPath: videoPath) { [self] postVideoURL in
            let docRef = currentUser.postsRef.document()
            let now = Timestamp(date: Date())
            self.locationManager.getLocation { [weak self] in
                self?.locationManager.getAddress { location in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let videoDocData: [String: Any] = [
                            "username": currentUser.profile.username,
                            "name": currentUser.profile.name,
                            "caption": caption, // pass captiontextfield text into here
                            "profilepic": currentUser.profile.profilePicURL, // some path to the user's profile pic
                            "url": postVideoURL ?? "",
                            "location": location ?? "",
                            "postType": "video",
                            "id": docRef.documentID,
                            "date": now,
                            "posterId": currentUser.profile.userID,
                            "numLikes": 0,
                            "comNum": 0,
                            "score": 0,
                            "usersWhoLiked": [""],
                        ]
                        self.createPost(data: videoDocData, documentRef: docRef)
                        self.caption = ""
                    }
                }
            }
        }
    }

    func uploadVideoToBunnyStorage(videoURL: URL, videoPath: String, completion: @escaping (String?) -> Void) {
        let storageZone = "campfireco-storage"
        let apiKey = "c86c082e-9e70-4d6f-82f4658c81a4-91f3-494a"

        let urlString = "https://storage.bunnycdn.com/\(storageZone)/\(videoPath)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue(apiKey, forHTTPHeaderField: "AccessKey")

            let task = URLSession.shared.uploadTask(with: request, fromFile: videoURL) { _, response, _ in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 201 {
                        let downloadURL = "https://campfirepullzone.b-cdn.net/\(videoPath)"
                        completion(downloadURL)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }

            task.resume()
        } else {
            completion(nil)
        }
    }
}
