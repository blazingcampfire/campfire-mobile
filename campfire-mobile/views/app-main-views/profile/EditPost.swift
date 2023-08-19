//
//  EditPost.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct EditPost: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    let initialImage: String
    @State var postImage: String
    @State var prompt: String
    let initialPrompt: String
    @State var index: Int
    @State private var promptScreen = false
    @EnvironmentObject var currentUser: CurrentUserModel
    @State var showAlert = false
    @State var post: [String : String]
    @State var changePic = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        
                    } else {
                        PostAttributes(url: postImage)
                    }
                    
                    Button(action: {
                        isPickerShowing = true
                    }) {
                        Image(systemName: "camera")
                            .font(.system(size: 100))
                            .foregroundColor(Theme.Peach)
                            .frame(width: 350, height: 350)
                            .background(Color.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        
                    }
                }
                
                ZStack {
                    HStack {
                        
                        Spacer()
                        
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.Peach)
                            .opacity(0)
                        
                        Spacer()
                        Spacer()
                        
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
                        
                        Spacer()
                        Spacer()
                        
                        if initialPrompt == prompt && !changePic {
                            VStack() {
                                Button(action: {
                                    withAnimation{
                                        
                                        self.showAlert.toggle()
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 20))
                                        .foregroundColor(Theme.Peach)
                                }
                            }
                        } else {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                                .foregroundColor(Theme.Peach)
                                .opacity(0)
                        }
                        
                        Spacer()
                    }
                }
                
                ZStack {
                    VStack {
                        if prompt != "no prompt" || (initialPrompt != prompt && prompt != "no prompt")  {
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
                        if initialPrompt != prompt || changePic {
                            HStack(spacing: 20) {
                                Button(action: {
                                    if changePic && initialPrompt != prompt {
                                        changeBoth(currentUser.profile.userID)
                                    } else if changePic {
                                        changePost(currentUser.profile.userID)
                                    } else if initialPrompt != prompt {
                                        changePrompt(currentUser.profile.userID)
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                    
                                }) {
                                    Text("confirm change")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.7), radius: 5, x: 2, y: 2)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Theme.TextColor, lineWidth: 0.3)
                                                )
                                        )
                                }
                                if initialPrompt != "no prompt" || changePic || initialPrompt != prompt {
                                    VStack() {
                                        Button(action: {
                                            withAnimation{
                                                
                                                self.showAlert.toggle()
                                            }
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 20))
                                                .foregroundColor(Theme.Peach)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 100)
            if self.showAlert {
                
                GeometryReader{_ in
                    
                    DeletePostAlert(showAlert: $showAlert, post: $post).environmentObject(currentUser)
                    
                }.background(
                    
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            
                            withAnimation{
                                
                                self.showAlert.toggle()
                            }
                        }
                    
                )
            }
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(sourceType: .photoLibrary) { image in
                self.selectedImage = image
            }
        }
        .onChange(of: selectedImage) { newImage in
            
            changePic = true
            
        }
        
    }
    
    func changePrompt(_ userID: String) {
        let docRef = currentUser.profileRef.document(userID)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                var data = document.data()!
                
                if var posts = data["posts"] as? [[String: String]] {
                    if let index = posts.firstIndex(where: { $0.keys.contains(postImage) }) {
                        posts[index][postImage] = prompt
                    }
                    data["posts"] = posts
                } else {
                    print("Error: 'posts' field is not an array of dictionaries.")
                    return
                }
                
                docRef.setData(data) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Successfully updated document")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }


    
    func changePost(_ userID: String) {
        
        guard let image = selectedImage else {
            print("No image selected.")
            return
        }
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard let imageData = imageData else {
            print("Image cannot be converted to data")
            return
        }
        
        let imagePath = "profilepostimages/\(UUID().uuidString).jpg"
        
        uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
            if let photoURL = photoURL {
                postImage = photoURL
               
                let docRef = currentUser.profileRef.document(userID)
                docRef.getDocument { document, error in
                    if let document = document, document.exists {
                        var data = document.data()!
                        
                        if var posts = data["posts"] as? [[String: String]] {
    
                            if let index = posts.firstIndex(where: { $0 == post }) {
                                posts[index] = [photoURL: prompt]
                            }
                            
                            data["posts"] = posts
                        } else {
            
                            data["posts"] = [[photoURL: prompt]]
                        }
                        
                        docRef.setData(data) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Successfully updated document")
                                
                                    if let index = currentUser.profile.posts.firstIndex(where: { $0 == post }) {
             
                                        currentUser.profile.posts[index] = [photoURL: prompt]
                                      
                                    }
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
    
    func changeBoth(_ userID: String) {
        guard let image = selectedImage else {
            print("No image selected.")
            return
        }

        let imageData = image.jpegData(compressionQuality: 0.8)
        guard let imageData = imageData else {
            print("Image cannot be converted to data")
            return
        }

        let imagePath = "profilepostimages/\(UUID().uuidString).jpg"
        
        uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
            if let photoURL = photoURL {
                let docRef = currentUser.profileRef.document(userID)
                docRef.getDocument { document, error in
                    if let document = document, document.exists {
                        var data = document.data()!
                        let newPost = [photoURL: prompt]

                        if var posts = data["posts"] as? [[String: String]] {
                            
                            if let index = posts.firstIndex(where: { $0 == post }) {
                                
                                posts[index] = [photoURL : prompt]
                                
                            }
                            data["posts"] = posts
                        }

                        docRef.setData(data) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Successfully updated document")
                                
                                var posts = currentUser.profile.posts 
                                    if let index = posts.firstIndex(where: { $0 == post }) {
                                        posts[index] = newPost
                                        currentUser.profile.posts = posts
                                    }
                                
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


    
    struct DeletePostAlert: View {
        
        @Binding var showAlert: Bool
        @EnvironmentObject var currentUser: CurrentUserModel
        @Binding var post: [String: String]
        
        
        
        var body: some View {
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 200, height: 100)
                    .foregroundColor(Color.white)
                    .overlay (
                        ZStack {
                            VStack {
                                HStack {
                                    Text("delete post?")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                }
                                .offset(y: 7)
                                Divider()
                                HStack {
                                    Button(action: {
                                        showAlert.toggle()
                                        
                                    }) {
                                        Text("cancel")
                                            .font(.custom("LexendDeca-Bold", size: 12))
                                            .foregroundColor(Theme.Peach)
                                            .padding()
                                    }
                                    .offset(x: -9, y: -9)
                                    Divider()
                                        .frame(height: 49)
                                        .offset(y: -8)
                                    Button(action: {
                                        deletePost(id: currentUser.profile.userID)
                                        showAlert.toggle()
                                    }) {
                                        Text("delete")
                                            .font(.custom("LexendDeca-Bold", size: 12))
                                            .foregroundColor(Theme.Peach)
                                            .padding()
                                    }
                                    .offset(x: 9, y: -9)
                                }
                            }
                            
                            
                        }
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.3)
                            )
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        func deletePost(id: String) {
            
            let docRef = currentUser.profileRef.document(id)
            docRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching user document: \(error)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document does not exist")
                    return
                }
                
                
                var userData = document.data() ?? [:]
                
                
                if var postsArray = userData["posts"] as? [[String: String]] {
                    
                    if let index = postsArray.firstIndex(where: { $0 == post }) {
                        
                        postsArray.remove(at: index)
                        
                        userData["posts"] = postsArray
                        
                        docRef.setData(userData) { error in
                            if let error = error {
                                print("Error updating user document: \(error)")
                            } else {
                                print("Post deleted successfully!")
                            }
                        }
                    } else {
                        print("Post not found in user's posts array")
                    }
                } else {
                    print("User's posts data is not an array or doesn't exist")
                }
            }
        }
    }
}



struct EditPost_Previews: PreviewProvider {
    static var previews: some View {
        Text("yo")
//        EditPost(postImage: <#Data#>, post: "ragrboard")
    }
}
