//
//  CamPostPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import SwiftUI
import AVKit

struct CamPostPage: View {
    
 //   @State private var player = AVPlayer()
    let feedinfo = FeedInfo()
    @State private var text: String = ""
    var captionText: String
    
    var body: some View {
        VStack(spacing: 50) {
           VStack {
            //    GeometryReader { geometry in
              //                     VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "david", withExtension: "mp4")!))
                    //                   .aspectRatio(1, contentMode: .fill) // Set //aspect ratio to 1:1 for square shape
                      //                 .frame(width: min(geometry.size.width, geometry.size.height)) // Adjust the frame to square shape
                          //             .clipped() // Clip the video to the square frame
                            //   }
                   
                
                 Image(feedinfo.feedpost)
                    .resizable()
                      .aspectRatio(contentMode: .fit)
                        .frame(width: 430, height:430)
                         .clipped()
            }
            
           //   .clipShape(RoundedRectangle(cornerRadius: 60))
            
            //    Spacer()
            VStack {
                TextField(captionText, text: $text)
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
                
                Divider()
                    .background(Color.black)
                    .frame(width: 365, height: 1)
                    .overlay(.black)
            }
            
            //      Spacer()
            Button(action: {
                
            }) {
                HStack(spacing: 10) {
                    Text("Post")
                        .font(.custom("LexendDeca-Bold", size: 25))
                        .foregroundColor(.white)
                    Image(systemName: "arrowshape.right.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
            .frame(width: 90, alignment: .center)
            .padding()
            .background(Theme.Peach)
            .cornerRadius(25)
        }
    }
}

struct CamPostPage_Previews: PreviewProvider {
    static var previews: some View {
        CamPostPage(captionText: "enter your caption")
    }
}
