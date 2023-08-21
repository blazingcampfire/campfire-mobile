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
                        .foregroundColor(.white)
                }
                .padding(.top, 2)
            }
            .padding(.leading, 20)
            VStack {
                CaptionTextField(text: $postModel.caption, placeholderText: "enter your caption")
            }
        }
        .padding(.bottom, 100)
        .padding(.top, 430)
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
                            } catch {
                                return
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
                            } catch {
                                return
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
                HStack(spacing: 5) {
                    Text(camera.isSaved ? "Saved" : "Save")
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-SemiBold", size: 21))
                    Image(systemName: camera.isSaved ? "checkmark" : "arrow.down")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 40).fill(Theme.Peach))
            }
        }
        .padding(.bottom, 30)
        .padding(.trailing, 260)
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
                HStack(spacing: 5) {
                    Text(camera.isSaved ? "Saved" : "Save")
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-SemiBold", size: 21))
                    Image(systemName: camera.isSaved ? "checkmark" : "arrow.down")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 40).fill(Theme.Peach))
            }
        }
        .padding(.bottom, 30)
        .padding(.trailing, 260)
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
