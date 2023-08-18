////
////  FirebaseManager.swift
////  campfire-mobile
////
////  Created by Adarsh G on 7/23/23.
////
//
//import SwiftUI
//import Firebase
//import FirebaseStorage
//
//class FirebaseManager: NSObject {
//    let storage: Storage
//    var id: String
//
//
//    init(id: String) {
//        self.id = id
//        self.storage = Storage.storage()
//        super.init()
//    }
//
//    static let shared = FirebaseManager(id: String())
//
//    func persistImageToStorage(image: Image, completion: @escaping (String?, Error?) -> Void) {
//            let ref = self.storage.reference(withPath: id)
//
//            // Convert SwiftUI Image to UIImage
//            guard let uiImage = imageToUIImage(image: image) else {
//                completion(nil, NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert SwiftUI Image to UIImage."]))
//                return
//            }
//
//            // Convert UIImage to Data
//            guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
//                completion(nil, NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to data."]))
//                return
//            }
//
//            ref.putData(imageData, metadata: nil) { metadata, error in
//                if let error = error {
//                    completion(nil, error)
//                    return
//                }
//
//                ref.downloadURL { url, error in
//                    if let error = error {
//                        completion(nil, error)
//                        return
//                    }
//
//                    if let downloadURL = url?.absoluteString {
//                        completion(downloadURL, nil)
//                    } else {
//                        completion(nil, NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve download URL."]))
//                    }
//                }
//            }
//        }
//
//    func updateUserDocument(withImageURL imageURL: String) {
//
//        let userRef = ndProfiles.document(self.id)
//
//        userRef.getDocument { document, error in
//            if let error = error {
//                print("Error getting user document: \(error.localizedDescription)")
//                return
//            }
//
//            if let document = document, document.exists {
//                // Get the current posts array from the document
//                var currentPosts = document.data()?["posts"] as? [String] ?? []
//
//                // Append the new post URL to the array
//                currentPosts.append(imageURL)
//
//                // Update the "posts" field with the updated array
//                userRef.updateData(["posts": currentPosts]) { error in
//                    if let error = error {
//                        print("Error updating user document: \(error.localizedDescription)")
//                    } else {
//                        print("User document updated successfully with post URL.")
//                    }
//                }
//            } else {
//                print("User document does not exist.")
//            }
//        }
//    }
//
//
//    func imageToUIImage(image: Image) -> UIImage? {
//        let controller = UIHostingController(rootView: image)
//        let view = controller.view
//
//        let targetSize = CGSize(width: 100, height: 100)
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: view?.bounds ?? CGRect.zero, afterScreenUpdates: true)
//        }
//    }
//
//}
