import SwiftUI
import FirebaseStorage

struct profileview: View {
    @State var showPhotos: Bool = false
    @State var selectedImage: UIImage?
    
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            ScrollView {
                
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        VStack {
                            ZStack {
                                
                                
                                Image("ragrboard")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 125, height: 125)
                                    .clipShape(Circle())
                                
                                
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
                        
                        
                        HStack {
                                                    VStack(alignment: .trailing, spacing: 20) {
                                                        HStack {
                                                            Text("adarsh")
                                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                            Spacer()
                                                            NavigationLink(destination: EditFieldPage(maxCharacterLength: 20, field: "name", currentfield: "currentUser.profile.name")) {
                                                                Label("edit name", systemImage: "pencil")
                                                                    .font(.custom("LexendDeca-Bold", size: 15))
                                                                    .foregroundColor(Theme.Peach)
                                                            }
                                                        }
                                                        HStack {
                                                            Text("wavy_darsh")
                                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                            Spacer()
                                                            NavigationLink(destination: EditFieldPage(maxCharacterLength: 20, field: "name", currentfield: "currentUser.profile.name")) {
                                                                Label("edit name", systemImage: "pencil")
                                                                    .font(.custom("LexendDeca-Bold", size: 15))
                                                                    .foregroundColor(Theme.Peach)
                                                            }
                                                        }
                                                        HStack {
                                                            Text("currentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.biocurrentUser.profile.bio")
                                                                .multilineTextAlignment(.center)
                                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                            Spacer()
                                                            NavigationLink(destination: EditFieldPage(maxCharacterLength: 20, field: "name", currentfield: "currentUser.profile.name")) {
                                                                Label("edit name", systemImage: "pencil")
                                                                    .font(.custom("LexendDeca-Bold", size: 15))
                                                                    .foregroundColor(Theme.Peach)
                                                            }
                                                        }
                                                    }
                                                    .padding(.leading, 20)
                                                    
                                                    Spacer() // Add a spacer to push the edit stacks to the left
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

struct profilevieww: PreviewProvider {
    static var previews: some View {
        profileview()
    }
}
