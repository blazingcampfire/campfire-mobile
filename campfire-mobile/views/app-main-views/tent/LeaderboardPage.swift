//
//  LeaderboardPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

let info = UserInfo()

struct LeaderboardPage: View {
    @StateObject var model: LeaderboardModel
    @State private var selectedOption = 5
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Leaderboard 👑")
                .font(.custom("LexendDeca-SemiBold", size: 20))
                .padding(.top, 15)
            
            Picker(selection: $selectedOption, label: Text("")) {
                Text("All-Time")
                .font(.custom("LexendDeca-SemiBold", size: 15))
                .tag(5)
                Text("Weekly")
                .font(.custom("LexendDeca-SemiBold", size: 15))
                .tag(6)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedOption == 5 {
                LeaderboardList(range: 1 ... 10)
                    .environmentObject(model)
                    .listStyle(InsetListStyle())
            } else if selectedOption == 6 {
                LeaderboardList(range: 1 ... 10)
                    .environmentObject(model)
                    .listStyle(InsetListStyle())
            }
        }
    }
}

struct LeaderboardList: View {
    
    @EnvironmentObject var model: LeaderboardModel
    
    let range: ClosedRange<Int>

    var body: some View {
        List {
            ForEach(model.profiles.indices, id: \.self) { index in
                HStack {
                    Text("\(index + 1)")
                        .frame(width: 30, alignment: .leading)
                        .font(.custom("LexendDeca-Bold", size: 18))
                        .padding(.trailing, -10)

                    Image(info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(model.profiles[index].name)
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .foregroundColor(Theme.TextColor)
                        Text("@\(model.profiles[index].username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("\(model.profiles[index].smores) 🍫")
                        .font(.custom("LexendDeca-Bold", size: 23))
                }
                .listRowBackground(Theme.ScreenColor)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 18, leading: 10, bottom: 15, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
}

//struct LeaderboardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardPage(model: LeaderboardModel())
//    }
//}
