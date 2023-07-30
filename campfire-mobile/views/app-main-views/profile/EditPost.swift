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
                            .offset(x: 0, y: selectedImage != nil ? 23 : 0)
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
                            .clipShape(Circle())
                            .offset(x: 0, y: selectedImage != nil ? 23 : 0)
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
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
    
    func changePrompt(_ userID: String) {
    }
}


struct EditPost_Previews: PreviewProvider {
    static var previews: some View {
        Text("yo")
//        EditPost(postImage: <#Data#>, post: "ragrboard")
    }
}
