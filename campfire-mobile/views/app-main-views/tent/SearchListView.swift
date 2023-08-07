//
//  SearchList.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI

struct SearchListView: View {
    var profilepic: String = info.profilepic
    var profile: Profile
    @State private var added: Bool = false
    @EnvironmentObject var model: SearchModel
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            HStack {
                
                Image(profilepic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                    .overlay (
                        NavigationLink(destination: { OtherProfilePage(profileModel: ProfileModel(id: profile.userID)) },
                                       label: { EmptyView() })
                        .opacity(0)
                        .frame(width: 10, height: 10)
                    )
                
                
                VStack(alignment: .leading) {
                    Text(profile.name)
                        .font(.custom("LexendDeca-Bold", size: 18))
                        .foregroundColor(Theme.TextColor)
                    Text("@\(profile.username)")
                        .font(.custom("LexendDeca-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button {
                    self.added.toggle()
                    model.requestFriend(profile: profile)
                } label: {
                    Image(systemName: self.added == false ? "plus.circle.fill" : "minus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(Theme.Peach)
                }
            }
        }
    }
}

// struct SearchListView_Previews: PreviewProvider {
//    static var previews: some View {
//       SearchListView()
//    }
// }
