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
    @EnvironmentObject var profileModel: ProfileModel
    @State var showAlert = false
    @State var post: [String : String]
    
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
                        .offset(y: 50)
                    }
                    
                    
                    if prompt != "no prompt" || initialPrompt != prompt  {
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
                            if initialPrompt != prompt {
                                Button(action: {
                                    changePrompt(profileModel.profile!.userID)
                                }) {
                                    Text("confirm change")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Theme.TextColor, lineWidth: 0.3)
                                                )
                                        )
                                }
                                .shadow(color: Color.black.opacity(0.7), radius: 5, x: 2, y: 2)
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
                if self.showAlert {
                    
                    GeometryReader{_ in
                        
                        DeletePostAlert(showAlert: $showAlert, post: $post).environmentObject(profileModel)
                        
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
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                
            }
        
    }
    
    func changePrompt(_ userID: String) {
        
    }
}

struct DeletePostAlert: View {
    
    @Binding var showAlert: Bool
    @EnvironmentObject var profileModel: ProfileModel
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
                                    deletePost(id: profileModel.profile!.userID)
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
        let docRef = ndProfiles.document(id)
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



struct EditPost_Previews: PreviewProvider {
    static var previews: some View {
        Text("yo")
//        EditPost(postImage: <#Data#>, post: "ragrboard")
    }
}
