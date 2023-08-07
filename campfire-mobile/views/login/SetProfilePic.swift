//
//  SetProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import FirebaseStorage
import PhotosUI
import SwiftUI

struct SetProfilePic: View {
    // setting up view dismiss == going back to the previous screen
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var model: AuthModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @State var setUpFinished: Bool = false
    @State var selectedPFP: UIImage?
    
    var body: some View {
        if model.isMainAppPresented {
            NavigationBar()
                .environmentObject(currentUser)
        }
        else {
            GradientBackground()
                .overlay(
                    VStack {
                        
                        // MARK: - Profile picture upload button & prompts
                        
                        VStack(spacing: 60) {
                            Text("upload a profile picture")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 25))
                                .padding(.top, 100)
                            Text("(optional)")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding(.top, -40)
                            
                            ProfilePictureView(selectedPFP: $selectedPFP)
                            
                            Text("you're ready!")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding(-20)
                            
                            // MARK: - Button redirecting to the main app
                            
                            VStack {
                                Button(action: {
                                    Task {
                                        do {
                                            try await confirmProfilePic()
                                            currentUser.setCollectionRefs()
                                            model.createProfile()
                                            currentUser.getProfile()
                                            currentUser.getUser()
                                            model.presentMainApp()
                                        } catch {
                                            print("Error setting profile picture: \(error)")
                                        }
                                    }
                                }) {
                                    LFButton(text: "finish")
                                }
                            }
                        }
                        .padding(.bottom, 200)
                    }
                )
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: Theme.ButtonColor))
        }
    }
    
    
    func confirmProfilePic() async throws {
        guard selectedPFP != nil else {
            print("No image")
            throw NSError(domain: "ImageUploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No image"])
        }
        
        guard let imageData = selectedPFP!.jpegData(compressionQuality: 0.8) else {
            print("Image cannot be converted to data")
            throw NSError(domain: "ImageUploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image cannot be converted to data"])
        }
        
        let imagePath = "pfpImages/\(UUID().uuidString).jpg"
        
        do {
            let photoURL = try await withCheckedThrowingContinuation { continuation in
                uploadToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
                    continuation.resume(returning: photoURL)
                }
            }
            print("0")
            print(photoURL)
            model.profilePic = photoURL!
            print("1")
            print(model.profilePic)
        } catch {
            print("Error uploading picture to storage: \(error)")
            throw error
        }
    }
    
    // Updated uploadToBunnyCDNStorage function with correct closure parameter
    func uploadToBunnyCDNStorage(imageData: Data, imagePath: String, completion: @escaping (String?) -> Void) {
        // Implement your code here to upload the image using GCD or other asynchronous techniques
        // For example, you can use Firebase Storage APIs to upload the image to BunnyCDN
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(imagePath)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        fileRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image to BunnyCDN:", error)
                completion(nil)
            } else {
                fileRef.downloadURL { url, error in
                    if let downloadURL = url {
                        completion(downloadURL.absoluteString)
                    } else {
                        print("Error retrieving download URL:", error?.localizedDescription ?? "Unknown error")
                        completion(nil)
                    }
                }
            }
        }
    }
}
