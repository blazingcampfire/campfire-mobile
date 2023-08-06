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
                    // MARK: - Back button
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                    }
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()
                    
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
                                do {
                                    confirmProfilePic()
                                    currentUser.setCollectionRefs()
                                    model.createProfile()
                                    currentUser.getProfile()
                                    currentUser.getUser()
                                    model.presentMainApp()
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
        }
    }
    
    func confirmProfilePic() {
            guard selectedPFP != nil else {
                print("No image")
                return
            }
        
            let imageData = selectedPFP!.jpegData(compressionQuality: 0.8)
            guard let imageData = imageData else {
                print("Image cannot be converted to data")
                return
            }
            

        let imagePath = "profilepictures/\(UUID().uuidString).jpg"
        
        uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
                if let photoURL = photoURL {
                    print(photoURL)
                    model.profilePic = photoURL
                    print(model)
                } else {
                    print("Error uploading picture to storage")
                }
            }
        }

}
        
        //    func processUploadPFP() async {
        //        guard let selectedImage = selectedImage else {
        //            print("No image")
        //            return
        //        }
        //
        //        let imageData = selectedImage.jpegData(compressionQuality: 0.8)
        //        if let imageData = imageData {
        //            let photoURL = await uploadPFPtoStorage(imageData: imageData)
        //            if let photoURL = photoURL {
        //                model.profilePic = photoURL
        //            } else {
        //                print("Error uploading profile picture")
        //            }
        //        }
        //    }
        //
        //    func uploadPFPtoStorage(imageData: Data) async -> String? {
        //        do {
        //            let storageRef = Storage.storage().reference()
        //            let path = "feedimages/\(UUID().uuidString).jpg"
        //            let fileRef = storageRef.child(path)
        //
        //            fileRef.putData(imageData)
        //            let photoURL = try await fileRef.downloadURL()
        //            return photoURL.absoluteString
        //        } catch {
        //            print("Error upload photo to storage: \(error.localizedDescription)")
        //            return nil
        //        }
        //    }
