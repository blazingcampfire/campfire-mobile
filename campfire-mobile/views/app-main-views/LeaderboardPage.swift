//
//  LeaderboardPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

let info = UserInfo()

struct LeaderboardPage: View {
    @State private var selectedOption = 5
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                Picker(selection: $selectedOption, label: Text("")) {
                    Text("All-Time").tag(5)
                    Text("Weekly").tag(6)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                //reusable for each row, color scheme
                if selectedOption == 5 {
                    LeaderboardList(range: 1...10)
                } else if selectedOption == 6 {
                    LeaderboardList(range: 1...10)
                }
                
            }
        }
    }
}

struct LeaderboardList: View {
    let range: ClosedRange<Int>
    
    var body: some View {
        
        
        List {
            ForEach(range, id: \.self) { number in
                HStack {
                    
                    
                    
                    Text("\(number)")
                    .frame(width: 30, alignment: .leading)
                    .font(.custom("LexendDeca-Bold", size: 18))
                    .padding(.trailing, -10)
                        
                        
                        
                    Image(info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    
                    VStack(alignment: .leading) {
                        Text(info.name)
                            .bold()
                        Text("@\(info.username)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("\(info.chocs) 🍫")
                        .font(.custom("LexendDeca-Bold", size: 23))
                    
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}


struct LeaderboardPage_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardPage()
    }
}
