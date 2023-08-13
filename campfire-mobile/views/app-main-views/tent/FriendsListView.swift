//
//  FriendsListView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI
import Kingfisher

struct FriendsListView: View {
    
    var request: RequestFirestore
    @EnvironmentObject var model: FriendsModel
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            HStack {
                // user image is passed in
                KFImage(URL(string: request.profilePicURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Button(action: {
                    }) {
                        Text(request.name)
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .foregroundColor(Theme.TextColor)
                    }
                    
                    Text("@\(request.username)")
                        .font(.custom("LexendDeca-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Button(action: {
                    model.removeFriend(request: request)
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(Theme.Peach)
                        .font(.custom("LexendDeca-Regular", size: 30))
                }
            }
        }
    }
}

//struct FriendsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsListView(profilepic: info.profilepic, name: info.name, username: info.username)
//    }
//}


