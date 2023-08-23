




//
//  CameraView.swift
//  customcam
//
//  Created by Femi Adebogun on 7/19/23.
//

import SwiftUI
import AVFoundation
import AVKit
import PhotosUI


struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    @EnvironmentObject var currentUser: CurrentUserModel
    @StateObject var post: CamPostModel
    @State private var flashTap: Bool = false
    @State private var camFlip: Bool = false
    @State private var isShowingCamPicker: Bool = false
    @State private var isPlaying: Bool = true
    @State private var isLoading = true
    @State var isRecording = false
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
            
            if camera.isVideoRecorded {
                if let recordedVideo = camera.videoPlayback {
                    CustomVideoPlayer(player: recordedVideo, isPlaying: $isPlaying)
                        .onTapGesture {
                            isPlaying.toggle()
                            UIApplication.shared.dismissKeyboard()
                        }
                }
                else {
                    Text("Error Loading Recorded Video")
                    .font(.custom("LexendDeca-Regular", size: 25))
                    .foregroundColor(.white)
                }
                 
                PreviewPostInfo(postModel: post)
                VideoPostButton(camera: camera, makePost: post)
                VideoSaveButton(camera: camera)
                RetakeButton(camera: camera)
                
            } else if camera.showSelectPhoto {
                    Color.black
                    .ignoresSafeArea(.all)
                if let selectedImageData = camera.selectedImageData,
                   let image = UIImage(data: selectedImageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                else {
                    Text("Error Loading Selected Image")
                        .font(.custom("LexendDeca-Regular", size: 25))
                        .foregroundColor(.white)
                }
                PreviewPostInfo(postModel: post)
                PhotoPostButton(camera: camera, makePost: post)
                
                VStack {
                    Button(action: {
                        camera.reTake()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.Peach)
                            .fontWeight(.bold)
                            .font(.system(size: 45))
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 330)

            } else if camera.showSelectVideo {
                    if let selectedVideoURL = camera.selectedVideoURL {
                        Group {
                            if isLoading {
                                ProgressView("Loading Video...")
                                    .font(.custom("LexendDeca-Regular", size: 25))
                                    .foregroundColor(.white)
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isLoading = false
                                        }
                                    }
                            }
                            else {
                                if let selectVideoPlayer = camera.selectVideoPlayer {
                                    CustomVideoPlayer(player: selectVideoPlayer, isPlaying: $isPlaying)
                                        .onTapGesture {
                                            isPlaying.toggle()
                                            UIApplication.shared.dismissKeyboard()
                                        }
                                }
                            }
                        }
                    }
                    else {
                        Text("Error Loading Selected Video")
                            .font(.custom("LexendDeca-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                    PreviewPostInfo(postModel: post)
                    .toolbar(.hidden, for: .tabBar)
                if !camera.videoTooLarge && !camera.videoSizeAlert {
                        VideoPostButton(camera: camera, makePost: post)
                    }
                    VStack {
                        Button(action: {
                            camera.reTake()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Theme.Peach)
                                .fontWeight(.bold)
                                .font(.system(size: 45))
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.leading, 330)
            }

            
            else if camera.isTaken  {
                if let uiImage = camera.capturedPic {
                    Image(uiImage: uiImage)
                       .resizable()
                       .scaledToFill()
                       .edgesIgnoringSafeArea(.all)
                }
                PhotoSaveButton(camera: camera)
                PreviewPostInfo(postModel: post)
                PhotoPostButton(camera: camera, makePost: post)
                RetakeButton(camera: camera)
                
            } else {
                ZStack() {
                    VStack(spacing: 10) {
                        Button(action: {
                            camera.isFlashOn.toggle()
                        }) {
                            Image(systemName: camera.isFlashOn ? "bolt.circle.fill" : "bolt.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                        }
                        Button(action: {
                            camera.rotateCamera()
                            self.camFlip.toggle()
                        }) {
                            Image(systemName: self.camFlip ? "arrow.triangle.2.circlepath.camera.fill" : "arrow.triangle.2.circlepath.camera" )
                                .foregroundColor(.white)
                                .font(.system(size: 35, weight: .semibold))
                        }
                        
                    }
                    .padding(.top, -330)
                    .padding(.leading, 290)
                    ZStack {
                        Button(action: {
                            isShowingCamPicker.toggle()
                        }) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 550)
                        .padding(.leading, 200)
                        .sheet(isPresented: $isShowingCamPicker) {
                            MediaPickerView()
                                .environmentObject(camera)
                        }
                        .onChange(of: camera.selectedImageData) { newImageData in
                            if let _ = newImageData {
                                camera.showSelectPhoto = true
                            }
                        }
                        .onChange(of: camera.selectedVideoURL) { newVideoURL in
                            if let _ = newVideoURL {
                                camera.showSelectVideo = true
                            }
                        }
                        ZStack {
                            // Base circle (white stroked)
                            Circle()
                                .stroke(Color.white, lineWidth: 10)
                            // Progress circle (red filled)
                            Circle()
                                .trim(from: 0, to: CGFloat(camera.progress))
                                .stroke(Color.red, lineWidth: 10)
                            // Rotate 90 degrees counter-clockwise to start from top
                                .rotationEffect(.degrees(-90))
                            // Animate any changes in progress
                                .animation(.linear(duration: 0.2), value: camera.progress)
                        }
                        .frame(width: 100, height: 100)
                        .contentShape(Rectangle())
                       .simultaneousGesture(tapGesture)
                       .simultaneousGesture(longPressGesture.sequenced(before: dragGesture))
                        .padding(.top, 530)
                    }
                    
                }
            }

        }
        .onTapGesture {
            UIApplication.shared.dismissKeyboard()
        }
        .alert(item: $camera.alertType) { alertType in
            switch alertType {
            case .accessDenied:
                return Alert(
                    title: Text("Camera Access Denied"),
                    message: Text("This app does not have access to your camera. Please enable access in your settings."),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text("Go to Settings"), action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    })
                )
            case .accessNotDetermined:
                return Alert(
                    title: Text("Access Not Determined"),
                    message: Text("This app does not have determined access to your camera roll. Please enable access in your settings."),
                    dismissButton: .default(Text("OK"))
                )
            case .cameraRollAccessDenied:
            return Alert(
                title: Text("Camera Roll Access Denied"),
                message: Text("This app does not have access to your camera roll. Please enable access in your settings."),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Go to Settings"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
            )
            case .sessionInterrupted:
            return Alert(
                title: Text("Camera Unavailable"),
                message: Text("Another application is using the camera."),
                dismissButton: .default(Text("Okay"))
            )
            }
        }
        .alert(isPresented: $camera.videoTooLarge) {
            Alert(title: Text("Video File Too Large"), message: Text("Consider Cropping Video"), dismissButton: .default(Text("OK")))
        }
    }
    var tapGesture: some Gesture {
            TapGesture()
                .onEnded {
                    camera.takePic()
                }
        }
    var dragGesture: some Gesture {
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { _ in
                    camera.stopRecording()
                }
        }

    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.3)
            .onEnded { _ in
                camera.startRecording()
            }
    }
    
}
