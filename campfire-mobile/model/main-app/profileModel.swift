import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class ProfileModel: ObservableObject {
    @Published var profile: Profile?
    var id: String
    
    init(id: String) {
        // Initialize the profile with an empty Profile object and id variable when the class is created.
        self.profile = Profile(name: "", phoneNumber: "", email: "", username: "", posts: [], postData: [], prompts: [], chocs: 0, profilePicURL: "", userID: id, school: "", bio: "")
        self.id = id
    }
    
    func getProfile() {
        let docRef = ndProfiles.document(id)
        docRef.getDocument(as: Profile.self) { result in
            // The Result type encapsulates deserialization errors or
            // successful deserialization, and can be handled as follows:
            //
            //      Result
            //        /\
            //   Error  Profile
            switch result {
            case .success(let profile):
                // A `Profile` value was successfully initialized from the DocumentSnapshot.
                print("Profile: \(profile)")
                print("Profile ID: \(profile.userID)")
                print("Posts: \(profile.posts)")
                var postPaths = profile.posts
                var fetchedImages = [Data]()
                
                for path in postPaths {
                    // uses the paths to refer to the right files in the Storage
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                 
                    // converts fileReference to data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        
                        if error == nil && data != nil {
                            
                            DispatchQueue.main.async {
                                print(fetchedImages)
                                print(data!)
                                fetchedImages.append(data!)
                                profile.postData = fetchedImages
                                self.profile = profile
                                print("yooo \(profile.postData)")
                            }
                        }
                    }
                }
                

                 // Update the profile property with the fetched profile.
            case .failure(let error):
                // A `Profile` value could not be initialized from the DocumentSnapshot.
                print("Error decoding profile in profileModel: \(error)")
                if let profile = self.profile {
                        // Use Mirror to introspect the properties of the profile and print their names and types
                        let profileMirror = Mirror(reflecting: profile)
                        print("Profile properties and types:")
                        for (name, value) in profileMirror.children {
                            if let propertyName = name {
                                print("\(propertyName): \(type(of: value))")
                            }
                        }
                    } else {
                        print("Profile is nil.")
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
