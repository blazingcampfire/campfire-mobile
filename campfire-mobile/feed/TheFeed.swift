//  TheFeed.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//
import SwiftUI
import AVKit

struct TheFeed: View {
    
    @State var currentVid = ""
    @State var vids = MediaFileJSON.map { item ->
        Vid in
        
        let url = Bundle.main.path(forResource: item.url, ofType: "mp4") ?? ""
        let player = AVPlayer(url: URL(fileURLWithPath: url))
       
        
        return Vid(player: player, mediafile: item)
    }
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            TabView(selection: $currentVid) {
                ForEach($vids){$vids in
                    VidsPlayer(vid: $vids, currentVid: $currentVid, caption: "when they get to dinking, they gon get to drinking")
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
        .onAppear {
            currentVid = vids.first?.id ?? ""
        }
    }
}

struct TheFeed_Previews: PreviewProvider {
    static var previews: some View {
        TheFeed()
    }
}

struct VidsPlayer: View {
    @Binding var vid: Vid
    @Binding var currentVid: String
    @State private var isPlaying = false
    var userInfo = UserInfo(name: "David", username: "@david_adegangbanger", profilepic: "ragrboard", marshcount: 100)
    var caption: String
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
                                Image(userInfo.profilepic)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                Text(userInfo.username)
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                
                            }
                            Text(caption)
                                .font(.custom("LexendDeca-Regular", size: 15))
                                .padding(.leading, 40)
                            
                        }
                        .padding(.top, 650)
                        Spacer(minLength: 20)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .bottom)
                VStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        
                    }) {
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    Button(action: {
                        
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 30, height: 8)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                }
                .padding(.top, 500)
                .padding(.leading, 325)
            }
        }
    }
}
