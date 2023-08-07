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
    
  
    //Edit this function to take in userId which passes currentUser.profile.id as a field on creation
    func createPhotoPost(imageData: Data) async throws {
        let imagePath = "feedpostimages/\(UUID().uuidString).jpg"
        uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { [self] photoURL in
        let docRef = ndPosts.document()
        let now = Timestamp(date: Date())
            self.locationManager.getLocation()
            locationManager.getAddress { location in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return }
                    let photoDocData: [String: Any] = [
                        "username": "davooo",
                        "name": "David Adebogun",
                        "caption": caption,    //pass captiontextfield text into here
                        "profilepic": "", // some path to the user's profile pic
                        "url": photoURL ?? "",
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
    }
        
    
    func createVideoPost(videoURL: URL) async throws {
        createVideoInBunnyLibrary(videoURL: videoURL) { storedURL in
            if let uploadedURL = storedURL {
            let docRef = ndPosts.document()
            let now = Timestamp(date: Date())
            self.locationManager.getLocation()
            self.locationManager.getAddress { location in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    let videoDocData: [String: Any] = [
                        "username": "davooo",
                        "name": "David Adebogun",
                        "caption": caption,    //pass captiontextfield text into here
                        "profilepic": "", // some path to the user's profile pic
                        "url": "\(uploadedURL)",
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
    }
    
    func uploadVideoToBunny(videoURL: URL, libraryId: Int, videoId: String, apiKey: String, completion: @escaping (URL?) -> Void) {
        let headers = ["accept": "application/json",
                       "AccessKey": apiKey]
        guard let urlString = URL(string: "https://video.bunnycdn.com/library/\(libraryId)/videos/\(videoId)") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: urlString, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let response = response as? HTTPURLResponse {
                print("Response: \(response)")
                completion(urlString)
            }
        }
        task.resume()
    }

    func createVideoInBunnyLibrary(videoURL: URL, completion: @escaping (URL?) -> Void) {
        let libraryId = 144921
        let apiKey = "f9de201a-2ee5-4229-a7d982399320-75ab-456d"
        let headers = ["accept": "application/json",
                       "content-type": "application/*+json",
                       "AccessKey": apiKey]
        let postData = "{\"title\": \"\(UUID().uuidString)\"}".data(using: String.Encoding.utf8)
        guard let urlString = URL(string: "https://video.bunnycdn.com/library/\(libraryId)/videos") else {
            completion(nil)
            return
        }
        var request = URLRequest(url: urlString, timeoutInterval: Double(10))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let response = response as? HTTPURLResponse,
                      let data = data {
                    print("Response: \(response)")
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let guid = json["guid"] as? String {
                            print("GUID: \(guid)")
                            self.uploadVideoToBunny(videoURL: videoURL, libraryId: libraryId, videoId: guid, apiKey: apiKey) { storageURL in
                                completion(storageURL)
                            }
                        }
                    } catch {
                        print("Error during JSON serialization: \(error.localizedDescription)")
                    }
                }
            }
        task.resume()
    }
}
