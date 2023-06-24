//
//  LeaderboardPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

struct LeaderboardPage: View {
    @State private var selectedOption = 5
    
    var body: some View {
                VStack(spacing: 0) {
                    Picker(selection: $selectedOption, label: Text("")) {
                        Text("All-Time").tag(5)
                        Text("Weekly").tag(6)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedOption == 5 {
                        LeaderboardList(range: 1...10)
                    } else if selectedOption == 6 {
                        LeaderboardList(range: 1...10)
                    }
        
        }
    }
}

struct LeaderboardList: View {
    let range: ClosedRange<Int>
    
    var body: some View {
        List {
            ForEach(range, id: \.self) { number in
                Text("Rank \(number)")
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
