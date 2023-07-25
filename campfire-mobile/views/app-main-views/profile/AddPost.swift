//
//  EditPost.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/22/23.
//

import SwiftUI
import FirebaseStorage

struct AddPost: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    @State private var promptScreen = false
    @Environment(\.presentationMode) var presentationMode
    

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
                                Text("add prompt")
                                    .font(.custom("LexendDeca-Bold", size: 20))
                                    .foregroundColor(Theme.Peach)
                            }
                            .sheet(isPresented: $promptScreen) {
                                PromptsPage()
                                    .presentationDetents([.fraction(0.7)])
                                    .presentationDragIndicator(.visible)
                                    .presentationCornerRadius(30)
                            }
                            Button(action: {
                                confirmPost()
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
    
    func confirmPost() {

        guard selectedImage != nil else {
            print ("no image")
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.5)
        
        guard imageData != nil else {
            print("image cannot be converted to data")
            return
        }
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let uploadTask = fileRef.putData(imageData!) { metadata, error in
            if error == nil && metadata != nil {
            }
        }
    }
}

struct AddPost_Previews: PreviewProvider {
    static var previews: some View {
        AddPost()
    }
}
