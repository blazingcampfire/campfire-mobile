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
        getProfile()
    }

    func getProfile() {
        let docRef = currentUser.profileRef.document(id)

        docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                return
            }

            guard let document = documentSnapshot, document.exists else {
                return
            }

            guard let profile = try? document.data(as: Profile.self) else {
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
            return
        }

        friendRelationshipRef.setData([
            "ownRequests": FieldValue.arrayUnion([userRequestField]),
        ], merge: true)

        userRelationshipRef.setData([
            "sentRequests": FieldValue.arrayUnion([friendRequestField]),
        ], merge: true)
        requested = true
    }

    func removeRequest() {
        guard let userID = Auth.auth().currentUser?.uid else {
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
            return
        }
        friendRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([userRequestField]),
            "sentRequests": FieldValue.arrayRemove([userRequestField]),
        ])

        userRelationshipRef.updateData([
            "ownRequests": FieldValue.arrayRemove([friendRequestField]),
            "sentRequests": FieldValue.arrayRemove([friendRequestField]),
        ])
        requested = false
    }

    func removeFriend() {
        guard let userID = Auth.auth().currentUser?.uid else {
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
            return
        }

        friendRelationshipRef.setData([
            "friends": FieldValue.arrayRemove([userRequestField]),
        ], merge: true)

        userRelationshipRef.setData([
            "friends": FieldValue.arrayRemove([friendRequestField]),
        ], merge: true)
        friend = false
    }

    func checkRequested(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        currentUser.relationshipsRef.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            } else {
                if let documentSnapshot = documentSnapshot {
                    let requests = documentSnapshot.get("ownRequests") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        if profile.userID == requestObject.userID {
                            self.requested = true
                        }
                    }
                }
            }
        }
    }

    func checkFriend(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        currentUser.relationshipsRef.document(currentUser.privateUserData.userID).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            } else {
                if let documentSnapshot = documentSnapshot {
                    let requests = documentSnapshot.get("friends") as? [[String: Any]] ?? []
                    for request in requests {
                        guard let requestObject = RequestFirestore(data: request) else {
                            return
                        }
                        if profile.userID == requestObject.userID {
                            self.friend = true
                        }
                    }
                }
            }
        }
    }
}
