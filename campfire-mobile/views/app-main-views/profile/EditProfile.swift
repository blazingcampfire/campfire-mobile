//
//  EditProfile.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI
import FirebaseStorage

struct EditProfile: View {
    @State var showPhotos: Bool = false
    @State var selectedImage: UIImage?
    @EnvironmentObject var profileModel: ProfileModel
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        ZStack {
                            if let image = selectedImage {
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 125, height: 125)
                                    .clipShape(Circle())
                                
                                
                            } else {
                                
                                UserProfilePic(pfp: profileModel.profile?.profilePicURL)}
                            
                            Button(action: {
                                showPhotos.toggle()
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .frame(width: 125, height: 125)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $showPhotos) {
                                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $showPhotos)
                            }
                        }
                        Text("change profile pic")
                            .font(.custom("LexendDeca-Bold", size: 20))
                            .foregroundColor(Theme.Peach)
                    }
                    
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(profileModel.profile!.name)
                                .font(.custom("LexendDeca-Bold", size: 15))
                            Text(profileModel.profile!.username)
                                .font(.custom("LexendDeca-Bold", size: 15))
                            Text(profileModel.profile!.bio)
                                .font(.custom("LexendDeca-Bold", size: 15))
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 20) {
                            NavigationLink(destination: EditFieldPage(field: "name", currentfield: profileModel.profile!.name)
                                .environmentObject(profileModel)) {
                                    Label("edit name", systemImage: "pencil")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                }
                            
                            NavigationLink(destination: EditFieldPage(field: "username", currentfield: profileModel.profile!.username)
                                .environmentObject(profileModel)) {
                                    Label("edit username", systemImage: "pencil")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                }
                            
                            NavigationLink(destination: EditFieldPage(field: "bio", currentfield: profileModel.profile!.bio)
                                .environmentObject(profileModel)) {
                                    Label("edit bio", systemImage: "pencil")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                }
                        }
                        .padding(.trailing, 20)
                    }
                    
                    if let postData = profileModel.profile?.posts {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 30) {
                                ForEach(Array(postData.enumerated()), id: \.element.self) { index, post in
                                    if let (imageData, prompt) = post.first {
                                        
                                        VStack(spacing: 20) {
                                            ZStack(alignment: .topTrailing) {
                                                PostAttributes(url: imageData, width: 300)
                                                
                                                Circle()
                                                    .foregroundColor(.white)
                                                    .frame(width: 50, height: 50)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(.gray, lineWidth: 0.5)
                                                            .frame(width: 50, height: 50)
                                                    )
                                                    .overlay(
                                                        NavigationLink(destination: EditPost(initialImage: imageData, postImage: imageData, prompt: prompt, initialPrompt: prompt, index: index)
                                                            .environmentObject(profileModel)){
                                                                Image(systemName: "pencil")
                                                                    .font(.system(size: 30))
                                                                    .foregroundColor(Theme.Peach)
                                                            }
                                                    )
                                                    .padding(EdgeInsets(top: -10, leading: 10, bottom: 0, trailing: -25))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 30)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                updateProfilePic(selectedImage: image, id: profileModel.profile?.userID ?? "")
            }
        }
    }
    
    
    func updateProfilePic(selectedImage: UIImage, id: String) {
        Task {
            do {
                let imageData = selectedImage.jpegData(compressionQuality: 0.8)
                let storageRef = Storage.storage().reference()
                let path = "pfpImages/\(UUID().uuidString).jpg"
                let fileRef = storageRef.child(path)
                
                let _ = try await fileRef.putDataAsync(imageData!)
                let link = try await fileRef.downloadURL()
                let photoURL = link.absoluteString
                
                let docRef = ndProfiles.document(id)
                docRef.getDocument { document, error in
                    if let document = document, document.exists {
                        var data = document.data()!
                        data["profilePicURL"] = photoURL
                        
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
            } catch {
                print("Error updating profile picture: \(error)")
            }
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        Text("yo")
        //        EditProfile(profileModel: ProfileModel(id: "s8SB7xYlJ4hbja3B8ajsLY76nV63"), postImages: <#[Post]#>)
    }
}
