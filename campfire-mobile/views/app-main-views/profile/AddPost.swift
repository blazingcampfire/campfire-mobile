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
    @Environment(\.presentationMode) var presentationMode
    @State var retrievedPosts = [Data]()
    @State var prompt: String = "no prompt"
    
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
                                // confirmPost function with current userID
                                // CHECK FUNC BELOW TONI
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
        
        // confirms that there is image
        guard selectedImage != nil else {
            print ("no image")
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        // convert type Image to type Data for storage
        let imageData = selectedImage!.jpegData(compressionQuality: 0.5)
        
        guard imageData != nil else {
            print("image cannot be converted to data")
            return
        }
        
        // string URL for database
        let path = "postImages/\(UUID().uuidString).jpg"
        
        // use path to create file reference for Firebase Storage
        let fileRef = storageRef.child(path)
        
        // put the converted imageData into the appropriate file reference
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil, metadata != nil {
                
                // file uploaded successfully, now update Firestore document
                let docRef = ndProfiles.document(userID)
                
                // fetch existing data and update firebase "posts" field
                docRef.getDocument { document, error in
                    if let document = document, document.exists {
                        var data = document.data()!
                        
                        // fetch posts field from current user as an array of strings
                        if var posts = data["posts"] as? [[String : String]] {
                            
                            // add new post URL to that array
                            posts.append([path: prompt])
                            data["posts"] = posts
                            
                            // update the profile information with added post
                            docRef.setData(data)
                            
                            // fetch from Firebase Storage
                            retrievePosts(userID: userID)
                            print("successfully retrieved posts")
                            
                        } else {
                            data["posts"] = [[path : prompt]]
                            docRef.setData(data)
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                print("Error up loading file: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func retrievePosts(userID: String) {
        // Same user document reference
        let docRef = ndProfiles.document(userID)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if let posts = document.data()?["posts"] as? [[String : String]] {
                    // postPaths is an array of post URLs from firebase 'posts' field.
                    
                    var fetchedPostsData = [[Data: String]]()
                    let dispatchGroup = DispatchGroup()
                    
                    for post in posts {
                        
                        if let postPath = post.keys.first, let prompt = post[postPath] {
                            
                            // uses the paths to refer to the right files in the Storage
                            let storageRef = Storage.storage().reference()
                            let fileRef = storageRef.child(postPath)
                            
                            dispatchGroup.enter()
                            
                            // converts fileReference to data
                            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                
                                
                                if let data = data, error == nil {
                                    
                                    let newPost = [data : prompt]
                                    // adds data to fetchedPostsData array
                                    fetchedPostsData.append(newPost)
                                    print("successfully grabbed imageData from Storage")
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        // all image data has been fetched, update 'profileModel.profile!.posts'

                        profileModel.profile!.postData = fetchedPostsData
                        print("postData object is correct!")
                        print(profileModel.profile!.postData)

                    }
                } else {
                    print("No 'posts' field or data is not of expected type.")
                }
            } else {
                print("Document does not exist or there was an error: \(String(describing: error))")
            }
        }
    }
}

    
//
//    struct AddPost_Previews: PreviewProvider {
//        static var previews: some View {
//            AddPost(profileModel: ProfileModel(id: "s8SB7xYlJ4hbja3B8ajsLY76nV63"))
//        }
//    }
