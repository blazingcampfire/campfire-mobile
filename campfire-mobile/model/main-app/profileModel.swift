import Foundation
import FirebaseFirestore

//struct Profile: Codable {
//    var firstName: String?
//    var phoneNumber: String
//    var email: String
//    var username: String
//    var friends: [Profile]?
//    var posts: [Post]?
//    var chocs: Int
//    var profilePicURL: String?
//}

class ProfileModel: ObservableObject {

    @Published var userID: String = "Adarsh"
    @Published var profileData: Profile?
    
  
    func fetchProfileData() {
        Task {
            do {
                let profile = try await self.getProfile()
                DispatchQueue.main.async {
                    self.profileData = profile
                }
            } catch {
                print("Error fetching profile: \(error)")
            }
        }
    }

    private func getProfile() async throws -> Profile {
        let snapshot = try await ndProfiles.document(userID).getDocument()

        guard let data = snapshot.data(),
              let userID = data["userID"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let email = data["email"] as? String,
              let username = data["username"] as? String,
              let chocs = data["chocs"] as? Int,
              let bio = data["bio"] as? String,
              let name = data["name"] as? String else {
            throw URLError(.badServerResponse)
        }

        return Profile(name: name, phoneNumber: phoneNumber, email: email, username: username, bio: bio, chocs: chocs, userID: userID)
    }
}
