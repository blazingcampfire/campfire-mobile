//
//  EditPost.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/22/23.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct AddPost: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    @State private var promptScreen = false
    @State var retrievedPosts = [Data]()
    @State var prompt: String = "no prompt"
    
    @Binding var showAddPost: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> 
    
    @EnvironmentObject var profileModel: ProfileModel
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                ZStack {
                    if let image = selectedImage {
                        VStack(spacing: 30) {
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .offset(x: 0, y: 0)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                
                                Button(action: {
                                    isPickerShowing = true
                                }) {
                                    Image(systemName: "camera")
                                        .font(.system(size: 100))
                                        .foregroundColor(Theme.Peach)
                                        .frame(width: 350, height: 350)
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                        .offset(x: 0, y: 0)
                                }
                            }
                            Button(action: {
                                self.promptScreen.toggle()
                            }) {
                                Text(prompt != "no prompt" ? "Change Prompt" : "Add Prompt")
                                    .font(.custom("LexendDeca-Bold", size: 20))
                                    .foregroundColor(Theme.Peach)
                            }
                            .sheet(isPresented: $promptScreen) {
                                PromptsPage(prompt: $prompt)
                                    .presentationDetents([.fraction(0.7)])
                                    .presentationDragIndicator(.visible)
                                    .presentationCornerRadius(30)
                            }
                            
                            if prompt != "no prompt" {
                                Spacer()
                                VStack {
                                    VStack {
                                        Text("prompt: ")
                                            .font(.custom("LexendDeca-SemiBold", size: 15))
                                            .foregroundColor(Theme.TextColor)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Theme.Peach)
                                                .frame(height: 50)
                                            
                                            Text(prompt)
                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                .foregroundColor(.white)
                                        }
                                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: 2, y: 2)
                                        .padding(.horizontal)
                                        .padding(.bottom, 20)
                                    }
                                }
                                .padding(.top, -30)
                            }
                            Button(action: {
                                confirmPost(userID: profileModel.profile!.userID, prompt: prompt)
                                print(profileModel.profile!.userID)
                                presentationMode.wrappedValue.dismiss()
                            })  {
                                HStack {
                                    Text("confirm post?")
                                        .font(.custom("LexendDeca-Bold", size: 25))
                                        .foregroundColor(Theme.Peach)
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 30))
                                        .foregroundColor(Theme.Peach)
                                }
                            }
                        }
                    } else {
                        Button(action: {
                            isPickerShowing = true
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 100))
                                .foregroundColor(Theme.Peach)
                                .frame(width: 350, height: 350)
                                .background(Color.black.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .offset(x: 0, y: 0)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .sheet(isPresented: $isPickerShowing) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
        }
    }
    
    func confirmPost(userID: String, prompt: String) {
            guard selectedImage != nil else {
                print("No image")
                return
            }
        
            print("check 1")
            print(profileModel.profile!.userID)
        
            let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
            guard let imageData = imageData else {
                print("Image cannot be converted to data")
                return
            }
            print("check 2")
            print(profileModel.profile!.userID)

            uploadPictureToStorage(imageData: imageData) { photoURL in
                if let photoURL = photoURL {
                    let docRef = ndProfiles.document(userID)
                    print("check 3")
                    print(profileModel.profile!.userID)
    
                    docRef.getDocument { document, error in
                        if let document = document, document.exists {
                            var data = document.data()!

                            if var posts = data["posts"] as? [[String: String]] {
                                posts.append([photoURL: prompt])
                                data["posts"] = posts
                            } else {
                                data["posts"] = [[photoURL: prompt]]
                            }

                            docRef.setData(data) { error in
                                if let error = error {
                                    print("Error updating document: \(error)")
                                } else {
                                    print("Successfully updated document")
                                    var posts = profileModel.profile!.posts
                                    posts.append([photoURL: prompt])
                                    profileModel.profile!.posts = posts
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                } else {
                    print("Error uploading picture to storage")
                }
            }
        }
    }
    
func uploadPictureToStorage(imageData: Data, completion: @escaping (String?) -> Void) {
    let storageRef = Storage.storage().reference()
    let path = "profilepostimages/\(UUID().uuidString).jpg"
    let fileRef = storageRef.child(path)

    fileRef.putData(imageData, metadata: nil) { _, error in
        if let error = error {
            print("Error upload photo to storage: \(error.localizedDescription)")
            completion(nil)
        } else {
            fileRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString)
                } else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
    }
}

