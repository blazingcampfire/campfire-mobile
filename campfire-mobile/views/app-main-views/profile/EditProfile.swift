import SwiftUI
import FirebaseStorage

struct EditProfile: View {
    @State var showPhotos: Bool = false
    @State var selectedImage: UIImage?
    @EnvironmentObject var currentUser: CurrentUserModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            ScrollView {
                
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        VStack {
                            ZStack {
                                if let image = selectedImage {
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 125, height: 125)
                                        .clipShape(Circle())
                                    
                                    
                                } else {
                                    
                                    UserProfilePic(pfp: currentUser.profile.profilePicURL)}
                                
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
                                    ImagePicker(sourceType:.photoLibrary) { image in
                                        self.selectedImage = image
                                    }
                                    
                                }
                            }
                            Text("change profile pic")
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .foregroundColor(Theme.Peach)
                        }
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text(currentUser.profile.name)
                                        .font(.custom("LexendDeca-Bold", size: 17))
                                    
                                    Spacer()
                                    
                                    
                                    
                                    NavigationLink(destination: EditFieldPage(maxCharacterLength: 20, unallowedCharacters: nameIllegalChar, field: "name", currentfield: currentUser.profile.name)
                                        .environmentObject(currentUser)) {
                                            Label("edit name", systemImage: "pencil")
                                                .font(.custom("LexendDeca-Bold", size: 17))
                                                .foregroundColor(Theme.Peach)
                                        }
                                    
                                }
                                HStack {
                                    Text(currentUser.profile.username)
                                        .font(.custom("LexendDeca-Bold", size: 17))
                                    Spacer()
                                    
                                    
                                    NavigationLink(destination: EditFieldPage(maxCharacterLength: 20, unallowedCharacters: usernameIllegalChar, field: "username", currentfield: currentUser.profile.username)
                                        .environmentObject(currentUser)) {
                                            Label("edit username", systemImage: "pencil")
                                                .font(.custom("LexendDeca-Bold", size: 17))
                                                .foregroundColor(Theme.Peach)
                                        }
                                    
                                }
                                HStack {
                                    Text(currentUser.profile.bio)
                                        .multilineTextAlignment(.center)
                                        .font(.custom("LexendDeca-Bold", size: 17))
                                    
                                    Spacer()
                                    
                                    
                                    
                                    NavigationLink(destination: EditFieldPage(maxCharacterLength: 50, field: "bio", currentfield: currentUser.profile.bio)
                                        .environmentObject(currentUser)) {
                                            Label("edit bio", systemImage: "pencil")
                                                .font(.custom("LexendDeca-Bold", size: 17))
                                                .foregroundColor(Theme.Peach)
                                        }
                                    
                                }
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                        }
                        
                        let postData = currentUser.profile.posts
                        if postData.count > 0 {
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
                                                        .shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 2)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(.gray, lineWidth: 0.5)
                                                                .frame(width: 50, height: 50)
                                                        )
                                                        .overlay(
                                                            NavigationLink(destination: EditPost(initialImage: imageData, postImage: imageData, prompt: prompt, initialPrompt: prompt, index: index, post: post)
                                                                .environmentObject(currentUser)){
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
                        else {
                            Spacer()
                            Spacer()
                            Text("no posts!")
                                .font(.custom("LexendDeca-Bold", size: 25))
                                .foregroundColor(Theme.Peach)
                                .padding(.top, 30)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: Theme.ButtonColor))
            .onChange(of: selectedImage) { newImage in
                if let image = newImage {
                    updateProfilePic(selectedImage: image, id: currentUser.profile.userID)
                }
            }
        }
    }
    
    func updateProfilePic(selectedImage: UIImage, id: String) {
        Task {
            do {
                guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                    print("Error converting image to data")
                    return
                }
                
                // Generate the UUID for the image path
                let imagePath = "pfpImages/\(UUID().uuidString).jpg"
                
                // Upload the image to BunnyCDN storage
                uploadPictureToBunnyCDNStorage(imageData: imageData, imagePath: imagePath) { photoURL in
                    if let photoURL = photoURL {
                        let docRef = currentUser.profileRef.document(id)
                        
                        docRef.getDocument { document, error in
                            if let document = document, document.exists {
                                var data = document.data()!
                                data["profilePicURL"] = photoURL
                                
                                docRef.setData(data) { error in
                                    if let error = error {
                                        print("Error updating document: \(error)")
                                    } else {
                                        print("Successfully updated document")
                                        currentUser.profile.profilePicURL = photoURL
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
