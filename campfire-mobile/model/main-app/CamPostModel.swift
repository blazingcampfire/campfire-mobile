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
    @Published var currentUser: CurrentUserModel
    @Published var caption: String = ""
    
    let locationManager = LocationManager()
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    
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
            let docRef = currentUser.postsRef.document()
        let now = Timestamp(date: Date())
            self.locationManager.getLocation { [weak self] in
                self?.locationManager.getAddress { location in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return }
                        let photoDocData: [String: Any] = [
                            "username": currentUser.profile.username,
                            "name": currentUser.profile.name,
                            "caption": self.caption,    //pass captiontextfield text into here
                            "profilepic": currentUser.profile.profilePicURL, // some path to the user's profile pic
                            "url": photoURL ?? "",
                            "location": location ?? "",
                            "postType": "image",
                            "id": docRef.documentID,
                            "date": now,
                            "posterId": currentUser.profile.userID,  //id of the person who posted
                            "numLikes": 0,
                            "comNum": 0,
                            "score": 0
                        ]
                        self.createPost(data: photoDocData, documentRef: docRef)
                        self.caption = ""
                        print("\(location ?? "")")
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
                        guard let self = self else {return}
                        let videoDocData: [String: Any] = [
                            "username": currentUser.profile.username,
                            "name": currentUser.profile.name,
                            "caption": caption,    //pass captiontextfield text into here
                            "profilepic": currentUser.profile.profilePicURL, // some path to the user's profile pic
                            "url": postVideoURL ?? "",
                            "location": location ?? "",
                            "postType": "video",
                            "id": docRef.documentID,
                            "date": now,
                            "posterId": currentUser.profile.userID,
                            "numLikes": 0,
                            "comNum": 0,
                            "score": 0
                        ]
                        self.createPost(data: videoDocData, documentRef: docRef)
                        self.caption = ""
                        print("\(location ?? "")")
                    }
                }
            }
        }
    }
    
    
    
    
//    func uploadVideoToBunny(videoURL: URL, libraryId: Int, videoId: String, apiKey: String, completion: @escaping (URL?) -> Void) {
//        let headers = ["accept": "application/json",
//                       "AccessKey": apiKey]
//        guard let urlString = URL(string: "https://video.bunnycdn.com/library/\(libraryId)/videos/\(videoId)") else {
//            completion(nil)
//            return
//        }
//
//        var request = URLRequest(url: urlString, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
//        request.httpMethod = "PUT"
//        request.allHTTPHeaderFields = headers
//
//        let task = URLSession.shared.uploadTask(with: request, fromFile: videoURL) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error)")
//                completion(nil)
//            } else if let response = response as? HTTPURLResponse {
//                print("Response: \(response)")
//                completion(urlString)
//            }
//        }
//        task.resume()
//    }
//
//    func createVideoInBunnyLibrary(videoURL: URL, completion: @escaping (URL?) -> Void) {
//        let libraryId = 144921
//        let apiKey = "2654e357-04c8-4c99-ae3c4680e468-e231-4568"
//        let headers = ["accept": "application/json",
//                       "content-type": "application/*+json",
//                       "AccessKey": apiKey]
//        let postData = "{\"title\": \"\(UUID().uuidString)\"}".data(using: String.Encoding.utf8)
//        guard let urlString = URL(string: "https://video.bunnycdn.com/library/\(libraryId)/videos") else {
//            completion(nil)
//            return
//        }
//        var request = URLRequest(url: urlString, timeoutInterval: Double(10))
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error)")
//            } else if let response = response as? HTTPURLResponse,
//                      let data = data {
//                print("Response: \(response)")
//
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let guid = json["guid"] as? String {
//                        print("GUID: \(guid)")
//                        self.uploadVideoToBunny(videoURL: videoURL, libraryId: libraryId, videoId: guid, apiKey: apiKey) { storageURL in
//                            // Create the playURL here with the given libraryId and guid
//                            guard let playURL = URL(string: "https://vz-a9802ad6-4ce.b-cdn.net/\(guid)/playlist.m3u8") else {
//                                completion(nil)
//                                return
//                            }
//                            completion(playURL)
//                        }
//                    }
//                } catch {
//                    print("Error during JSON serialization: \(error.localizedDescription)")
//                }
//            }
//        }
//        task.resume()
//    }
    
    func uploadVideoToBunnyStorage(videoURL: URL, videoPath: String, completion: @escaping (String?) -> Void) {
        let storageZone = "campfireco-storage"
        let apiKey = "c86c082e-9e70-4d6f-82f4658c81a4-91f3-494a"
        
        let urlString = "https://storage.bunnycdn.com/\(storageZone)/\(videoPath)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue(apiKey, forHTTPHeaderField: "AccessKey")
            
            let task = URLSession.shared.uploadTask(with: request, fromFile: videoURL) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 201 {
                        
                        let downloadURL = "https://campfirepullzone.b-cdn.net/\(videoPath)"
                        completion(downloadURL)
                    } else {
                        print("Error uploading image: HTTP Status Code:", response.statusCode)
                        completion(nil)
                    }
                } else {
                    print("Error uploading image:", error?.localizedDescription ?? "Unknown error")
                    completion(nil)
                }
            }
            
            task.resume()
        } else {
            print("Error: Invalid URL")
            completion(nil)
        }
        
    }
        
//    public func createFile(bucket: String, key: String, withData data: Data) async throws {
//        let dataStream = ByteStream.from(data: data)
//
//        let input = PutObjectInput(
//            body: dataStream,
//            bucket: bucket,
//            key: key
//        )
//        _ = try await client.putObject(input: input)
//    }




//    let headers = [
//      "Content-Type": "application/json",
//      "Upload-Creator": "",
//      "Upload-Metadata": "",
//      "X-Auth-Email": ""
//    ]
//    let parameters = [
//      "allowedOrigins": ["example.com"],
//      "creator": "creator-id_abcde12345",
//      "meta": ["name": "video12345.mp4"],
//      "requireSignedURLs": true,
//      "scheduledDeletion": "2014-01-02T02:20:00Z",
//      "thumbnailTimestampPct": 0.529241,
//      "url": "https://example.com/myvideo.mp4",
//      "watermark": ["uid": "ea95132c15732412d22c1476fa83f27a"]
//    ] as [String : Any]
//
//    let postData = JSONSerialization.data(withJSONObject: parameters, options: [])
//
//    let request = NSMutableURLRequest(url: NSURL(string: "https://api.cloudflare.com/client/v4/accounts/account_identifier/stream/copy")! as URL,
//                                            cachePolicy: .useProtocolCachePolicy,
//                                        timeoutInterval: 10.0)
//    request.httpMethod = "POST"
//    request.allHTTPHeaderFields = headers
//    request.httpBody = postData as Data
//
//    let session = URLSession.shared
//    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//      if (error != nil) {
//        print(error)
//      } else {
//        let httpResponse = response as? HTTPURLResponse
//        print(httpResponse)
//      }
//    })
//
//    dataTask.resume()
    
    
}
