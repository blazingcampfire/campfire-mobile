//
//  SearchList.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI
import Kingfisher

struct SearchListView: View {
    var profile: Profile
    @State private var added: Bool = false
    @EnvironmentObject var model: SearchModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            HStack {
                    HStack {
                        KFImage(URL(string: profile.profilePicURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(profile.name)
                                .font(.custom("LexendDeca-Bold", size: 18))
                                .foregroundColor(Theme.TextColor)
                            Text("@\(profile.username)")
                                .font(.custom("LexendDeca-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .overlay (
                        NavigationLink(destination: {
                            if profile.userID == currentUser.profile.userID {
                                OwnProfilePage()
                                    .environmentObject(currentUser)
                                    .environmentObject(notificationsManager)
                            }
                            else {
                                OtherProfilePage(profileModel: ProfileModel(id: profile.userID, currentUser: currentUser))
                            }
                        }
                            ,
                                                           label: { EmptyView() })
                                            .opacity(0)
                                            .frame(width: 10, height: 10)
                    )
                    
                    Spacer()
                    
                    Button(action: {
                        self.added.toggle()
                        model.requestFriend(profile: profile)
                    }) {
                        Image(systemName: self.added == false ? "plus.circle.fill" : "minus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Theme.Peach)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }

                }
            }
        }
    

// struct SearchListView_Previews: PreviewProvider {
//    static var previews: some View {
//       SearchListView()
//    }
// }

