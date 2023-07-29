//
//  ProfilePictureView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//

import SwiftUI

struct ProfilePictureView: View {
    var profilePicture: String?
    @State var isPickerShowing = false
    // bool to check new pfp
    @State var selectedImage: UIImage?
    
    var body: some View {
        if selectedImage == nil {
            VStack {
                Button {
                    isPickerShowing.toggle()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        // have to fix placeholder
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Theme.Peach)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            
                            .background(Color.white)
                            .clipShape(Circle())
                        
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .background(Theme.Peach)
                            .clipShape(Circle())
                    }
                }
                .sheet(isPresented: $isPickerShowing) {
                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
           
            }
        }
        else {
            VStack {
                Button {
                    isPickerShowing.toggle()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        // have to fix placeholder
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Theme.Peach)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                            .background(Color.white)
                            .clipShape(Circle())
                        
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .background(Theme.Peach)
                            .clipShape(Circle())
                    }
                }
                .sheet(isPresented: $isPickerShowing) {
                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                }
                
            }
        }
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView()
    }
}
