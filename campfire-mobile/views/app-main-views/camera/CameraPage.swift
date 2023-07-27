////
////  CameraPage.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 6/20/23.
////
//
//import SwiftUI
//import SwiftUICam
//
//struct CameraPage: View, CameraActions {
//    @State private var flashTapped: Bool = false
//    @State private var camFlipped: Bool = false
//    @State var initialMessageShow = false
//    @State var photoAlbumShow = false
//    @State var selectedImage: Image?
//    @ObservedObject var events: UserEvents
//
//    var body: some View {
//        ZStack {
//           
//        VStack(spacing: 10) {
//            
//            Button(action: {
//           //     self.flashTapped.toggle()
//            }) {
//                Image(systemName: self.flashTapped == true ? "bolt.circle" : "bolt.circle.fill")
//                    .foregroundColor(.black)
//                    .font(.system(size: 40))
//            }
//            .onTapGesture {
//                changeFlashMode(events: events)
//            }
//            
//            Button(action: {
//           //     self.camFlipped.toggle()
//            }) {
//                Image(systemName: self.camFlipped == true ? "arrow.triangle.2.circlepath.camera" : "arrow.triangle.2.circlepath.camera.fill")
//                    .foregroundColor(.black)
//                    .font(.system(size: 35, weight: .semibold))
//            }
//            .onTapGesture {
//                self.rotateCamera(events: events)
//            }
//            
//        }
//        .padding(.top, -300)
//        .padding(.leading, 290)
//        
//        VStack {
//            Spacer()
//            
//            HStack(spacing: 25) {
//                
//                //-MARK: Take pic or vid button
//                Button(action: {
//                   // print("yay")
//                }) {
//                    Circle()
//                        .fill(Color.clear)
//                        .frame(width: 100, height: 90)
//                        .overlay(
//                            Circle()
//                                .stroke(Color.black, lineWidth: 10)
//                        )
//                }
//                .onTapGesture {
//                    self.takePhoto(events: events)
//                }
//                .padding(.bottom, 10)
//                
//                //-MARK: Upload pictures button
//                Button(action: {
//                    photoAlbumShow.toggle()
//                }) {
//                    Image(systemName: "photo.on.rectangle.angled")
//                        .font(.system(size: 25))
//                        .foregroundColor(.black)
//                }
//                .sheet(isPresented: $photoAlbumShow) {
//                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $photoAlbumShow)
//                        .presentationDragIndicator(.visible)
//                }
//            }
//            .padding(.leading, 55)
//        }
//        .padding(.bottom, 25)
//    }
//        .edgesIgnoringSafeArea(.top)
//    }
//}
//
//struct CameraPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraPage(events: UserEvents())
//    }
//}
