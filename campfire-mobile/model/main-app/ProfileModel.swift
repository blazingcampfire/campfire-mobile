import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

class ProfileModel: ObservableObject {
    @Published var profile: Profile?
    @Published var currentUser: CurrentUserModel
    @Published var requested: Bool = false
    @Published var friend: Bool = false
    var id: String

    init(id: String, currentUser: CurrentUserModel) {
        self.id = id
        self.currentUser = currentUser
        self.getProfile()
    }
    
   
    
    
    
    func getProfile() {
        let docRef = currentUser.profileRef.document(id)

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
                if profile.userID != self.currentUser.profile.userID {
                    self.checkRequested(profile: profile)
                    self.checkFriend(profile: profile)
                }
                self.profile = profile
            } else {
                for path in postPaths {
                    if let (imageData, prompt) = path.first {
                        DispatchQueue.main.async {
                            if profile.userID != self.currentUser.profile.userID {
                                self.checkRequested(profile: profile)
                                self.checkFriend(profile: profile)
                            }
                            self.profile = profile
                        }
                    }
                }
            }
        }
    }

    func requestFriend() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        guard let friendID = profile?.userID else {
            return
        }
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        var friendRequestField: [String: Any]
        var userRequestField: [String: Any]

        do {
            friendRequestField = try Firestore.Encoder().encode(Request(userID: friendID, name: profile!.name, username: profile!.username, profilePicURL: profile!.profilePicURL))
            userRequestField = try Firestore.Encoder().encode(Request(userID: userID, name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL))
        } catch {
            print("Could not encode requestFields.")
            return
        }

        print(friendRelationshipRef.documentID)
        friendRelationshipRef.setData([
            "ownRequests": FieldValue.arrayUnion([userRequestField]),
        ], merge: true)

        userRelationshipRef.setData([
            "sentRequests": FieldValue.arrayUnion([friendRequestField]),
        ], merge: true)
        self.requested = true
    }
    
    func removeRequest() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        guard let friendID = profile?.userID else {
            return
        }
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        var friendRequestField: [String: Any]
        var userRequestField: [String: Any]

        do {
            friendRequestField = try Firestore.Encoder().encode(Request(userID: friendID, name: profile!.name, username: profile!.username, profilePicURL: profile!.profilePicURL))
            userRequestField = try Firestore.Encoder().encode(Request(userID: userID, name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL))
        } catch {
            print("Could not encode requestFields.")
            return
        }
        friendRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([userRequestField]),
        ])

        userRelationshipRef.updateData([
            "sentRequests": FieldValue.arrayRemove([friendRequestField]),
        ])
        self.requested = false
    }

    func removeFriend() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("You are not currently authenticated.")
            return
        }
        guard let friendID = profile?.userID else {
            return
        }
        let friendRelationshipRef = currentUser.relationshipsRef.document(friendID)
        let userRelationshipRef = currentUser.relationshipsRef.document(userID)
        var friendRequestField: [String: Any]
        var userRequestField: [String: Any]

        do {
            friendRequestField = try Firestore.Encoder().encode(Request(userID: friendID, name: profile!.name, username: profile!.username, profilePicURL: profile!.profilePicURL))
            userRequestField = try Firestore.Encoder().encode(Request(userID: userID, name: currentUser.profile.name, username: currentUser.profile.username, profilePicURL: currentUser.profile.profilePicURL))
        } catch {
            print("Could not encode requestFields.")
            return
        }

        print(friendRelationshipRef.documentID)
        friendRelationshipRef.setData([
            "friends": FieldValue.arrayRemove([userRequestField]),
        ], merge: true)

        userRelationshipRef.setData([
            "friends": FieldValue.arrayRemove([friendRequestField]),
        ], merge: true)
        self.friend = false
    }


    func checkRequested(profile: Profile?) {
        guard let profile = profile else {
            print("returning")
            return
        }
        currentUser.relationshipsRef.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let documentSnapshot = documentSnapshot {
                    let requests = documentSnapshot.get("ownRequests") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        if profile.userID == requestObject.userID {
                            print("Should be true")
                            self.requested = true
                        }
                    }
                }
            }
        }
        print(requested)
    }
    
    func checkFriend(profile: Profile?) {
        guard let profile = profile else {
            print("returning")
            return
        }
        currentUser.relationshipsRef.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let documentSnapshot = documentSnapshot {
                    let requests = documentSnapshot.get("friends") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        if profile.userID == requestObject.userID {
                            print("Should be true")
                            self.friend = true
                        }
                    }
                }
            }
        }
        print(friend)
    }
}

// if let postPaths = document.data()?["posts"] as? [String] {
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
// } else {
//    print("No 'posts' field or data is not of expected type.")
// }
// } else {
// print("Document does not exist or there was an error: \(String(describing: error))")
// }
// }
// }
// }
