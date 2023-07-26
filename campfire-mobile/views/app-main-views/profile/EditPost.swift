//
//  EditPost.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct EditPost: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    var postImage: Data
    var prompt: String?
    
    @State private var promptScreen = false
    
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
                            .overlay(
                                PostAttributes(image: postImage, prompt: prompt)
                            )
                    } else {
                        PostAttributes(image: postImage, prompt: prompt)
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
                    Text(prompt != nil ? "Change Prompt" : "Add Prompt")
                        .font(.custom("LexendDeca-Bold", size: 20))
                        .foregroundColor(Theme.Peach)
                }
                .sheet(isPresented: $promptScreen) {
                    PromptsPage()
                        .presentationDetents([.fraction(0.7)])
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(30)
                }
                
            }
            .padding(.bottom, 100)
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
}


struct EditPost_Previews: PreviewProvider {
    static var previews: some View {
        Text("yo")
//        EditPost(postImage: <#Data#>, post: "ragrboard")
    }
}
