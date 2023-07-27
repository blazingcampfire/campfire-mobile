




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
    
    @ObservedObject var camera: CameraModel
    @ObservedObject var userData: AuthModel
    @State private var flashTap: Bool = false
    @State private var camFlip: Bool = false
    @State private var isShowingCamPicker: Bool = false
    @State private var showSelectedPhoto: Bool = false
    @State private var showSelectedVideo: Bool = false
    @State private var isPlaying: Bool = true
    @State private var isLoading = true
    @State var isRecording = false
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                    .ignoresSafeArea(.all, edges: .all)
            
            if camera.isVideoRecorded {
                if let recordedVideo = camera.videoPlayback {
                    CustomVideoPlayer(player: recordedVideo, isPlaying: $isPlaying)
                        .onTapGesture {
                            isPlaying.toggle()
                        }
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("Error Loading Recorded Video")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                }
                 
                PreviewPostInfo(userData: userData)
                .padding(.top, 500)
                PostButton()
                
                VStack(alignment: .leading) {
                    Spacer()
                    Button(action: {
                        if !camera.isSaved{camera.saveVideo()}
                    }) {
                        Text(camera.isSaved ? "saved" : "save")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .background(Theme.Peach)
                            .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 30)
                .padding(.trailing, 300)
                
        
                VStack{
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
                .padding(.trailing, 330)
                
            } else if showSelectedPhoto {
                    Color.black
                    .ignoresSafeArea(.all)
                if let selectedImageData = camera.selectedImageData,
                   let image = UIImage(data: selectedImageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("Error Loading Selected Image")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                PreviewPostInfo(userData: userData)
                    .padding(.top, 500)
                
                PostButton()
                
                VStack {
                    Button(action: {
                        camera.reTake()
                        self.showSelectedPhoto = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.Peach)
                            .fontWeight(.bold)
                            .font(.system(size: 45))
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.trailing, 330)

            } else if showSelectedVideo {
                if let selectedVideoURL = camera.selectedVideoURL {
                Group {
                    if isLoading {
                        ProgressView("Loading Video...")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isLoading = false
                                }
                            }
                    
                }
                    else {
                        CustomVideoPlayer(player: AVPlayer(url: selectedVideoURL), isPlaying: $isPlaying)
                            .onTapGesture {
                                isPlaying.toggle()
                            }
                            .onAppear {
                                isPlaying = true
                            }
                            .edgesIgnoringSafeArea(.all)
                            .aspectRatio(9/16, contentMode: .fill)
                    }
                    }
                } else {
                    Text("Error Loading Selected Video")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                
                PreviewPostInfo(userData: userData)
                .padding(.top, 500)
                
              PostButton()
                
                VStack {
                    Button(action: {
                        camera.reTake()
                        self.showSelectedVideo = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.Peach)
                            .fontWeight(.bold)
                            .font(.system(size: 45))
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.trailing, 330)
            }
            
            else if camera.isTaken  {
                
                if let uiImage = camera.capturedPic {
                    Image(uiImage: uiImage)
                       .resizable()
                       .scaledToFill()
                       .edgesIgnoringSafeArea(.all)
                }
                VStack(alignment: .leading) {
                    Spacer()
                    Button(action: {
                        if !camera.isSaved{camera.savePic()}
                    }) {
                        Text(camera.isSaved ? "saved" : "save")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .background(Theme.Peach)
                            .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 30)
                .padding(.trailing, 300)
                
                PreviewPostInfo(userData: userData)
                    .padding(.top, 500)
                
                PostButton()
                
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
                .padding(.trailing, 330)
                
            } else {
                ZStack() {
                    VStack(spacing: 10) {
                        Button(action: {
                            camera.toggleFlash()
                            self.flashTap.toggle()
                        }) {
                            Image(systemName: self.flashTap == false ? "bolt.circle" : "bolt.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                        }
                        Button(action: {
                            camera.rotateCamera()
                            self.camFlip.toggle()
                        }) {
                            Image(systemName: self.camFlip == false ? "arrow.triangle.2.circlepath.camera" : "arrow.triangle.2.circlepath.camera.fill" )
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
                        .padding(.top, 600)
                        .padding(.leading, 200)
                        .sheet(isPresented: $isShowingCamPicker) {
                            MediaPickerView()
                                .environmentObject(camera)
                        }
                        .onChange(of: camera.selectedImageData) { newImageData in
                            if let _ = newImageData {
                                self.showSelectedPhoto = true
                            }
                        }
                        .onChange(of: camera.selectedVideoURL) { newVideoURL in
                            if let _ = newVideoURL {
                                self.showSelectedVideo = true
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
                        .padding(.top, 600)
                    }
                    
                }
            }

        }
        .onAppear {
            self.camera.checkCameraPermission()
        }
        .onDisappear {
            self.camera.tearDown()
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
       
    
        

    }
    var tapGesture: some Gesture {
            TapGesture()
                .onEnded {
                    print("tapped")
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
        LongPressGesture(minimumDuration: 0.7)
            .onEnded { _ in
                camera.startRecording()
            }
    }
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(camera: CameraModel(), userData: AuthModel())
    }
}
