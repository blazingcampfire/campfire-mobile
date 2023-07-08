//  TheFeed.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//
import SwiftUI
import AVKit



struct CamPostPage: View {
    @State var currentVid = ""
    @State var vids = PostFileJSON.map { item in
        switch item.mediaType {
        case .video:
            let url = Bundle.main.path(forResource: item.url, ofType: "mov") ?? ""
            let player = AVPlayer(url: URL(fileURLWithPath: url))
            return Vid(player: player, mediafile: item)
        case .image:
            return Vid(player: nil, mediafile: item)
        }
    }
        //The vids sets up a switch statement that reads the mediaType of Vid struct
        // Then sets up what happens for the image or video, the video url is initialized here
    
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $currentVid) {
                ForEach($vids){ $vids in
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

struct CamPostPage_Previews: PreviewProvider {
    static var previews: some View {
        CamPostPage()
    }
}
    
struct CamPostPlayer: View {
    @Binding var vid: Vid
    @Binding var currentVid: String
    @State private var likeTapped: Bool = false
    @State private var HotSelected = true
    let feedinfo = FeedInfo()
    var userInfo = UserInfo(name: "David", username: "@david_adegangbanger", profilepic: "ragrboard", chocs: 100)
    
    
    //-MARK: Sets up the VideoPlayer for the video case and the creates the image url and handles image case
    var body: some View {
        ZStack {
                    switch vid.mediafile.mediaType {
                    case .video:
                        if let player = vid.player {
                            CustomVideoPlayer(player: player, isPlaying: $vid.isPlaying)
                                .onTapGesture {
                                   vid.isPlaying.toggle()
                                    vid.manuallyPaused.toggle()
                                }
                                .onChange(of: currentVid) { value in
                                    vid.isPlaying = vid.id == value
                                    if !vid.isPlaying {
                                    player.seek(to: .zero)
                                        }
                                    if vid.isPlaying {
                                        player.play()
                                    }
                                    }
                        }
                
            case .image:
                // Construct the file path
                if let imagePath = Bundle.main.path(forResource: vid.mediafile.url, ofType: "jpeg"),
                   let uiImage = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    // Handle image not found case
                    Text("Image not found")
                }
            }
               
                
                
            Button(action: {
                //go back to map page
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
            }
            .padding(.top, -325)
            .padding(.leading, -175)
            
                
                
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
                                    // lead to profile page
                                }) {
                                    Text(userInfo.username)
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                }
                            }
                            .padding(.bottom, 30)
                            .padding(.leading, 20)
                            
                            
                            
                            //- MARK: Caption/Location buttons Vstack
                            VStack(alignment: .center, spacing: 5) {
                                
                                CaptionTextField(placeholderText: "enter your caption")

                                Button(action: {
                                    // lead to map and where location is
                                }) {
                                    HStack {
                                        Text(userInfo.location)
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }
                             
                                }
                                .frame(alignment: .trailing)
                            }
                
                        }
                    }
                  
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 30)
                
                
            }
        .background(Color.black.ignoresSafeArea())
        }
    }
