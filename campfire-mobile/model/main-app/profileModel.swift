import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



class ProfileModel: ObservableObject {
    
    var profile: Profile?
    var id: String = "YN9kGX0TYaRQBbtQUdJb7ODwjYt1"

    func getProfile(id: String) {
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
            case .failure(let error):
                // A `Profile` value could not be initialized from the DocumentSnapshot.
                print("Error decoding city: \(error)")
            }
        }
    }
}


