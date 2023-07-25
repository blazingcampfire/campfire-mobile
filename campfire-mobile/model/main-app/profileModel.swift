import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class ProfileModel: ObservableObject {
    @Published var profile: Profile?  
    var id: String

    init(id: String) {
        // Initialize the profile with an empty Profile object and id variable when the class is created.
        self.profile = Profile(name: "", phoneNumber: "", email: "", username: "", posts: [], chocs: 0,  profilePicURL: "", userID: id, school: "", bio: "")
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
                self.profile = profile // Update the profile property with the fetched profile.
            case .failure(let error):
                // A `Profile` value could not be initialized from the DocumentSnapshot.
                print("Error decoding profile: \(error)")
            }
        }
    }
}
