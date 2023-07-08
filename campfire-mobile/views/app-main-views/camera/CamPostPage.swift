//
//  CamPostPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import AVKit
import SwiftUI

struct CamPostPage: View {
    @State var currentVid = ""
    @State var vids = MediaFileJSON.map { item ->
        Vid in

        let url = Bundle.main.path(forResource: item.url, ofType: "mp4") ?? ""
        let player = AVPlayer(url: URL(fileURLWithPath: url))

        return Vid(player: player, mediafile: item)
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $currentVid) {
                ForEach($vids) { $vids in
                    CamPostPlayer(vid: $vids, currentVid: $currentVid)
                        .frame(width: size.width)
                        .rotationEffect(.init(degrees: -90))
                        .ignoresSafeArea(.all, edges: .top)
                }
            }
            .rotationEffect(.init(degrees: 90))
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: size.width)
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.ignoresSafeArea())
        //      .onAppear {
        //        currentVid = vids.first?.id ?? ""
        //  }
    }
}

struct CamPostPage_Previews: PreviewProvider {
    static var previews: some View {
        CamPostPage()
    }
}

struct CamPostPlayer: View {
    @Binding var vid: Vid
    @Binding var currentVid: String
    @State private var isPlaying = false

    let feedinfo = FeedInfo()

    var userInfo = UserInfo(name: "David", username: "@david_adegangbanger", profilepic: "ragrboard", chocs: 100)
    var body: some View {
        ZStack {
            if let player = vid.player {
                CustomVideoPlayer(player: player, isPlaying: $isPlaying)
                    .onTapGesture {
                        isPlaying.toggle()
                    }
                    .onAppear {
                        isPlaying = true
                    }
                    .onDisappear {
                        isPlaying = false
                        player.seek(to: .zero)
                    }
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    let size = proxy.size
                    DispatchQueue.main.async {
                        if -minY < (size.height / 2) && minY < (size.height / 2) && currentVid == vid.id {
                            isPlaying = true
                        } else {
                            isPlaying = false
                        }
                    }
                    return Color.clear
                }
                VStack {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 10) {
                                Button(action: {
                                    // lead to profile page
                                }) {
                                    Image(userInfo.profilepic)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }

                                Button(action: {
                                    // lead to profile page
                                }) {
                                    Text(userInfo.username)
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                }
                            }
                            .padding(.bottom, 25)
                            .padding(.leading, 20)
                            VStack(spacing: 7) {
                                CaptionTextField(placeholderText: "enter your caption")

                                Button(action: {
                                    // lead to map and where location is
                                }) {
                                    Text("📍 37 High Street")
                                        .font(.custom("LexendDeca-Regular", size: 17))
                                }
                                .frame(alignment: .trailing)
                            }

                            ZStack {
                                Button(action: {
                                }) {
                                    HStack(spacing: 4.5) {
                                        Text("post")
                                            .font(.custom("LexendDeca-Bold", size: 21))
                                            .foregroundColor(.white)
                                        Image(systemName: "arrowshape.right.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 22))
                                    }
                                }
                                .frame(width: 80, alignment: .center)
                                .padding()
                                .background(Theme.Peach)
                                .cornerRadius(25)
                            }
                            .padding(.leading, 275)
                            .padding(.top, 45)
                        }
                        .padding(.top, 510)
                        Spacer(minLength: 20)
                    }
                    .padding(.leading, 5)
                }
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
        }
    }
}
