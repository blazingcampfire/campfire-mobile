//
//  PreviewPostInfo.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/27/23.
//

import SwiftUI
import FirebaseStorage
import AVKit


struct PreviewPostInfo: View {
    @ObservedObject var userData: AuthModel
    @ObservedObject var postModel: CamPostModel
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Image(userData.profilePic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack {
                    Text("@\(userData.username)")
                        .font(.custom("LexendDeca-Bold", size: 14))
                        .foregroundColor(Theme.TextColor)
                }
                .padding(.top, 2)
            }
            .padding(.leading, 20)
            VStack(alignment: .leading, spacing: 10) {
                CaptionTextField(text: $postModel.caption, placeholderText: "enter your caption")
                Text("📍Location")
                .font(.custom("LexendDeca-Regular", size: 16))
                .padding(.leading, 15)
            }
        }
        .padding(.bottom, 100)
        .padding(.top, 500)
    }
}

struct PhotoPostButton: View {
    @ObservedObject var camera: CameraModel
    @ObservedObject var makePost: CamPostModel
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Button(action: {
                if let imageData = camera.capturedPic?.jpegData(compressionQuality: 0.8) ?? camera.selectedImageData {
                    Task {
                        do {
                            try await makePost.createPhotoPost(imageData: imageData)
                            camera.reTake()
                            print("success")
                        } catch {
                            print(error)
                        }
                    }
                }
            }) {
                HStack(spacing: 7) {
                Text("post")
                .foregroundColor(.white)
                .font(.custom("LexendDeca-SemiBold", size: 22))
                Image(systemName: "arrowshape.right.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 40).fill(Theme.Peach))
            }
        }
        .padding(.bottom, 30)
        .padding(.leading, 250)
    }
}

struct VideoPostButton: View {
    @ObservedObject var camera: CameraModel
    @ObservedObject var makePost: CamPostModel
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Button(action: {
                if let videoURL = camera.selectedVideoURL ?? (camera.videoPlayback?.currentItem?.asset as? AVURLAsset)?.url {
                    Task {
                        do {
                            try await makePost.createVideoPost(videoURL: videoURL)
                            camera.reTake()
                            print("Video post created.")
                        } catch {
                            print(error)
                        }
                    }
                }
            }) {
                HStack(spacing: 7) {
                Text("post")
                .foregroundColor(.white)
                .font(.custom("LexendDeca-SemiBold", size: 22))
                Image(systemName: "arrowshape.right.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 40).fill(Theme.Peach))
            }
        }
        .padding(.bottom, 30)
        .padding(.leading, 250)
    }
}


struct PhotoSaveButton: View {
    @ObservedObject var camera: CameraModel
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Button(action: {
                if !camera.isSaved{camera.savePic()}
            }) {
                Circle()
                .overlay(
                Image(systemName: self.camera.isSaved ? "checkmark.circle.fill" : "arrow.down.circle.fill")
                    .foregroundColor(.white)
                    .background(Theme.Peach)
                    .font(.system(size: 30))
                    .clipShape(Circle())
                )
                .frame(width: 50, height: 50)
            }
        }
        .padding(.bottom, 30)
        .padding(.trailing, 315)
    }
}

struct VideoSaveButton: View {
    @ObservedObject var camera: CameraModel
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Button(action: {
                if !camera.isSaved{camera.saveVideo()}
            }) {
                Circle()
                .overlay(
                Image(systemName: self.camera.isSaved ? "checkmark.circle.fill" : "arrow.down.circle.fill")
                    .foregroundColor(.white)
                    .background(Theme.Peach)
                    .font(.system(size: 30))
                    .clipShape(Circle())
                )
                .frame(width: 50, height: 50)
            }
        }
        .padding(.bottom, 30)
        .padding(.trailing, 315)
    }
}

struct RetakeButton: View {
    @ObservedObject var camera: CameraModel
    var body: some View {
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
}




struct PreviewPostInfo_Previews: PreviewProvider {
    static var previews: some View {
        PreviewPostInfo(userData: AuthModel(), postModel: CamPostModel())
    }
}
