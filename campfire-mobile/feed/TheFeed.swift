//  TheFeed.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//
import SwiftUI
import AVKit

struct TheFeed: View {
    @State var currentVid = ""
    @State var vids = MediaFileJSON.map { item in
        switch item.mediaType {
        case .video:
            let url = Bundle.main.path(forResource: item.url, ofType: "mov") ?? ""
            let player = AVPlayer(url: URL(fileURLWithPath: url))
            return Vid(player: player, mediafile: item)
        case .image:
            return Vid(player: nil, mediafile: item)
        }
    }
        
    
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $currentVid) {
                ForEach($vids){$vids in
                    VidsPlayer(vid: $vids, currentVid: $currentVid)
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
            if let firstVid = vids.first {
                currentVid = firstVid.id
                vids[0].isPlaying = true
            }
        }
    }
}
//In this view a Tabview is iterating over the VidsPlayer View and setting up the vertical scroll ui component
//VidsPlayer handles the specific actions of what each case should look like

struct TheFeed_Previews: PreviewProvider {
    static var previews: some View {
        TheFeed()
    }
}

    
struct VidsPlayer: View {
    @Binding var vid: Vid
    @Binding var currentVid: String
    @State private var likeTapped: Bool = false
    
    @State private var HotSelected = true
    @State var leaderboardPageShow = false
    let feedinfo = FeedInfo()
    
    var userInfo = UserInfo(name: "David", username: "@david_adegangbanger", profilepic: "ragrboard", chocs: 100)
    
    
    //-MARK: Sets up the VideoPlayer for the video case and the creates the image url and handles image case
    var body: some View {
        ZStack {
            switch vid.mediafile.mediaType {
            case .video:
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
                }
                
            case .image:
                // Construct the file path
                if let imagePath = Bundle.main.path(forResource: vid.mediafile.url, ofType: "jpeg"),
                   let uiImage = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                      //  .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                } else {
                    // Handle image not found case
                    Text("Image not found")
                }
            }
               
                
                
                
               //- MARK: Hot/New button
                VStack {
                    HStack {
                        Button(action: {
                            HotSelected = true
                        }) {
                            Text("Hot")
                                .font(.custom("LexendDeca-Bold",                 size:35))
                                .opacity(HotSelected ? 1.0 : 0.5)
                        }
                        
                        Rectangle()
                            .frame(width: 2, height: 30)
                            .opacity(0.75)
                        Button(action: {
                            HotSelected = false
                        }) {
                            Text("New")
                                .font(.custom("LexendDeca-Bold", size: 35))
                                .opacity(HotSelected ? 0.5 : 1.0)
                        }
                    }
                    .padding(.top, 60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .foregroundColor(.white)
            
            VStack {
                HStack {
                    Button(action: {
                        leaderboardPageShow.toggle()
                    }) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $leaderboardPageShow) {
                        LeaderboardPage()
                         //   .presentationDetents([.large])
                    }
                }
                .padding(.top, 65)
                .padding(.leading, 310)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            
            
                
                
                //-MARK: User information
                VStack {
                    HStack(alignment: .bottom) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            
                            //- MARK: Profile pic/username buttons Hstack
                            HStack(spacing: 10) {
                                
                                Button(action: {
                                    // lead to profile page
                                }) {
                                    Image(userInfo.profilepic)
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                }
                                .padding(.bottom, 5)
                                
                                
                                Button(action: {
                                    //lead to profile page
                                }) {
                                    Text(userInfo.username)
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                }
                            }
                            
                            //- MARK: Caption/Location buttons Vstack
                            VStack(spacing: 5) {
                                HStack {
                                    Text(feedinfo.postcaption)
                                        .font(.custom("LexendDeca-Regular", size: 15))
                                }
                                .padding(.leading, -30)
                                
                                Button(action: {
                                    //lead to map and where location is
                                }) {
                                    HStack {
                                        Text("📍37 High Street")
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }
                             
                                }
                                .frame(alignment: .trailing)
                            }
                        }
                    }
                    .padding(.leading, 40)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 30)
                .padding(.leading, -20)
                
                
                //-MARK: End of profile info
                
                
                //-MARK: Three buttons on side
                VStack(spacing: 7.5) {
                    
                    VStack(spacing: -60) {
                        Button(action: {
                            //like post
                            self.likeTapped.toggle()
                        }) {
                            VStack {
                                Image(self.likeTapped == false ? "eaten" : "noteaten")
                            }
                            .padding(.leading, -15)
                        }
                        Text("\(feedinfo.likecount)")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 16))
                    }
                    
                    
                    VStack {
                    Button(action: {
                        // comment
                    }) {
                        VStack {
                            Image(systemName: "text.bubble.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                        }
                    }
                    Text("\(feedinfo.commentnum)")
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-Regular", size: 16))
                }
                    .padding(.top, 20)
                    
                    Button(action: {
                        //report post
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 30, height: 8)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                }
                .padding(.bottom, 155)
                .padding(.trailing, -30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        .background(Color.black.ignoresSafeArea())
    }
}
