//
//  CameraPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/20/23.
//

import SwiftUI

struct CameraPage: View {
    @State private var flashTapped: Bool = false
    @State var initialMessageShow = false
    @State var photoAlbumShow = false
    @State var selectedImage: Image?

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)

            VStack(spacing: 10) {
                Button(action: {
                    print("flip camera")
                    self.flashTapped.toggle()
                }) {
                    Image(systemName: self.flashTapped == true ? "bolt.circle" : "bolt.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                }

                Button(action: {
                    print("flip camera")
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .semibold))
                }
            }
            .padding(.top, -300)
            .padding(.leading, 290)

            VStack {
                Spacer()
            
                HStack(spacing: 25) {
          
                    //-MARK: Take pic or vid button
                    Button(action: {
                        print("yay")
                    }) {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 100, height: 90)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 10)
                            )
                    }
                    .padding(.bottom, 10)
                    
            //-MARK: Upload pictures button
                    Button(action: {
                        photoAlbumShow.toggle()
                    }) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $photoAlbumShow) {
                        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $photoAlbumShow)
                            .presentationDragIndicator(.visible)
                    }
                }
                .padding(.leading, 55)
            }
            .padding(.bottom, 25)
        }
    }
}

struct CameraPage_Previews: PreviewProvider {
    static var previews: some View {
        CameraPage()
    }
}
