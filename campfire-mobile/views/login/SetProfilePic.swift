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
    @EnvironmentObject var notificationsManager: NotificationsManager
    @State var setUpFinished: Bool = false
    @State var selectedPFP: UIImage?
    
    var body: some View {
        if setUpFinished {
            NavigationBar()
                .environmentObject(currentUser)
                .onAppear {
                    if !notificationsManager.hasPermission {
                        Task {
                            await notificationsManager.request()
                        }
                    }
                }
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
                .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: .white))
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
                uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
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
}
