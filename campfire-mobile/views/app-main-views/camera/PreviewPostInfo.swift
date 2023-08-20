//
//  PreviewPostInfo.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/27/23.
//

import SwiftUI
import FirebaseStorage
import AVKit
import Kingfisher

struct PreviewPostInfo: View {
    @ObservedObject var currentUser: CurrentUserModel
    @ObservedObject var postModel: CamPostModel
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                KFImage(URL(string: currentUser.profile.profilePicURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack {
                    Text("@\(currentUser.profile.username)")
                        .font(.custom("LexendDeca-Bold", size: 14))
                        .foregroundColor(Theme.TextColor)
                }
                .padding(.top, 2)
            }
            .padding(.leading, 20)
            VStack {
                CaptionTextField(text: $postModel.caption, placeholderText: "enter your caption")
            }
        }
        .padding(.bottom, 100)
        .padding(.top, 400)
    }
}

struct PhotoPostButton: View {
    @ObservedObject var camera: CameraModel
    @ObservedObject var makePost: CamPostModel
    @State private var isPosting: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            if isPosting {
                ProgressView("Posting...")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .foregroundColor(.white)
            }
            else {
                Button(action: {
                    if let imageData = camera.capturedPic?.jpegData(compressionQuality: 0.8) ?? camera.selectedImageData {
                        isPosting = true
                        Task {
                            do {
                                try await makePost.createPhotoPost(imageData: imageData)
                                camera.reTake()
                                isPosting = false
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
        }
        .padding(.bottom, 30)
        .padding(.leading, 250)
    }
}

struct VideoPostButton: View {
    @ObservedObject var camera: CameraModel
    @ObservedObject var makePost: CamPostModel
    @State private var isPosting: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            if isPosting {
                ProgressView("Posting...")
                .font(.custom("LexendDeca-Regular", size: 20))
                .foregroundColor(.white)
            } else {
                Button(action: {
                    if let videoURL = camera.selectedVideoURL ?? (camera.videoPlayback?.currentItem?.asset as? AVURLAsset)?.url {
                        isPosting = true
                        Task {
                            do {
                                try await makePost.createVideoPost(videoURL: videoURL)
                                camera.reTake()
                                isPosting = false
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




//struct PreviewPostInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewPostInfo(currentUser: CurrentUserModel())
//    }
//}
