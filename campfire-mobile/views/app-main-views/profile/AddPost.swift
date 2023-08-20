////
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
    
    @EnvironmentObject var currentUser: CurrentUserModel
    
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
                            }
                            
                            if prompt != "no prompt" {
                                Spacer()
                                VStack {
                                    VStack {
                                        Text("prompt: ")
                                            .font(.custom("LexendDeca-SemiBold", size: 15))
                                            .foregroundColor(Theme.TextColor)
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Theme.Peach)
                                            .frame(height: 50)
                                            .overlay(
                                                HStack {
                                                    Text(prompt)
                                                        .font(.custom("LexendDeca-Bold", size: 15))
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                    Spacer()
                                                    Button(action: {
                                                        prompt = "no prompt"
                                                    }) {
                                                        Image(systemName: "xmark.circle")
                                                            .font(.system(size: 25))
                                                            .foregroundColor(Color.white)
                                                    }
                                                    .padding(.trailing)
                                                }
                                            )
                                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: 2, y: 2)
                                        .padding(.horizontal)
                                        .padding(.bottom, 20)
                                    }
                                }
                                .padding(.top, -30)
                            }
                            Button(action: {
                                confirmPost(userID: currentUser.profile.userID, prompt: prompt)
                                
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
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.selectedImage = image
                }
            }
        }
    }
    
    func confirmPost(userID: String, prompt: String) {
        guard let selectedImage = selectedImage else {
            print("No image")
            return
        }
        
        let imageData = selectedImage.jpegData(compressionQuality: 0.8)
        guard let imageData = imageData else {
            print("Image cannot be converted to data")
            return
        }
        
        // Generate the UUID for the image path
        let imagePath = "profilepostimages/\(UUID().uuidString).jpg"
        
        // Upload the image to BunnyCDN storage
        uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
            if let photoURL = photoURL {
                let docRef = currentUser.profileRef.document(userID)
                print(photoURL)
                
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
                                var posts = currentUser.profile.posts
                                posts.append([photoURL: prompt])
                                currentUser.profile.posts = posts
                                print(currentUser.profile.posts)
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

//    func uploadPictureToStorage(imageData: Data, completion: @escaping (String?) -> Void) {
//        let storageRef = Storage.storage().reference()
//        let path = "profilepostimages/\(UUID().uuidString).jpg"
//        let fileRef = storageRef.child(path)
//
//        fileRef.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                print("Error upload photo to storage: \(error.localizedDescription)")
//                completion(nil)
//            } else {
//                fileRef.downloadURL { url, error in
//                    if let url = url {
//                        completion(url.absoluteString)
//                    } else {
//                        print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
//                        completion(nil)
//                    }
//                }
//            }
//        }
//    }

func uploadPictureToBunnyCDNStorage(imageData: Data, imagePath: String, completion: @escaping (String?) -> Void) {
    guard let storageZone = ProcessInfo.processInfo.environment["storageZone"] else {
          return
      }
      guard let apiKey = ProcessInfo.processInfo.environment["apiKey"] else {
          return
      }

    let urlString = "https://storage.bunnycdn.com/\(storageZone)/\(imagePath)"
    print(urlString)
    if let url = URL(string: urlString) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(apiKey, forHTTPHeaderField: "AccessKey")

        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 201 {
                   
                    let downloadURL = "https://campfirepullzone.b-cdn.net/\(imagePath)"
                    completion(downloadURL)
                } else {
                    print("Error uploading image: HTTP Status Code:", response.statusCode)
                    completion(nil)
                }
            } else {
                print("Error uploading image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
            }
        }

        task.resume()
    } else {
        print("Error: Invalid URL")
        completion(nil)
    }
}

