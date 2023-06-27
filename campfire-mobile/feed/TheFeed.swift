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
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
