//
//  ProfilePictureView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//

import SwiftUI

struct ProfilePictureView: View {
    @State var isPickerShowing = false
    // bool to check new pfp
    @Binding var selectedPFP: UIImage?
    
    
    var body: some View {
        Button(action: {
            isPickerShowing.toggle()
        }) {

            if let image = selectedPFP {
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Theme.Peach)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                
                    .background(Color.white)
                    .clipShape(Circle())
               
                
            } else {
                
                ZStack(alignment: .bottomTrailing) {
                  
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color.white)
                        .background(Theme.Peach)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 30)
                                .frame(width: 120.0, height: 120.0)
                        )
                        .clipShape(Circle())
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .background(Theme.Peach)
                        .clipShape(Circle())
                }
            }
              }
        .sheet(isPresented: $isPickerShowing) {
                ImagePicker(sourceType: .photoLibrary) { image in
                self.selectedPFP = image
            }
        }
    }
}

