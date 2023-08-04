import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class ProfileModel: ObservableObject {
    @Published var profile: Profile?
    var id: String
    
    init(id: String) {
        
        self.id = id
        self.getProfile()
    }
    
    func getProfile() {
        let docRef = ndProfiles.document(id)
        
        docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("Document does not exist or there was an error.")
                return
            }
            
            guard let profile = try? document.data(as: Profile.self) else {
                print("Error decoding profile in profileModel.")
                return
            }
            
            let postPaths = profile.posts
            
            if postPaths.isEmpty {
                DispatchQueue.main.async {
                    self.profile = profile
                }
            } else {
                for path in postPaths {
                    if let (imageData, prompt) = path.first {
                        DispatchQueue.main.async {
                            self.profile = profile
                        }
                    }
                }
            }
        }
    }
}



//if let postPaths = document.data()?["posts"] as? [String] {
//    // postPaths is an array of post URLs from firebase 'posts' field.
//
//    var fetchedPostsData = [Data]()
//    let dispatchGroup = DispatchGroup()
//
//    for path in postPaths {
//
//        // uses the paths to refer to the right files in the Storage
//        let storageRef = Storage.storage().reference()
//        let fileRef = storageRef.child(path)
//
//        dispatchGroup.enter()
//
//        // converts fileReference to data
//        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//
//
//            if let data = data, error == nil {
//
//                // adds data to fetchedPostsData array
//                fetchedPostsData.append(data)
//                print("successfully grabbed imageData from Storage")
//            }
//            dispatchGroup.leave()
//        }
//    }
//
//    dispatchGroup.notify(queue: .main) {
//        // all image data has been fetched, update 'profileModel.profile!.posts'
//
//        profileModel.profile!.postData = fetchedPostsData
//        print("Retrieved data into 'profileModel.profile!.posts' array")
//        print(profileModel.profile!) // this is currently printing campfire_mobile.Profile, but it must print a real object
//
//    }
//} else {
//    print("No 'posts' field or data is not of expected type.")
//}
//} else {
//print("Document does not exist or there was an error: \(String(describing: error))")
//}
//}
//}
//}


