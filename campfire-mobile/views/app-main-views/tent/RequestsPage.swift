//
//  RequestsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/3/23.

import SwiftUI

struct RequestsPage: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            ListRequests(range: 1 ... 12)
                .listStyle(PlainListStyle())
        }
        .searchable(text: $searchText)
        .background(Color.white)
        .padding(.top, -10)
    }
}

struct ListRequests: View {
    let range: ClosedRange<Int>

    var body: some View {
        List {
            ForEach(range, id: \.self) { _ in
                HStack {
                    // user image is passed in
                    Image(info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Button(action: {
                        }) {
                            Text(info.name)
                                .font(.custom("LexendDeca-Bold", size: 18))
                                .foregroundColor(.black)
                        }

                        Text("@\(info.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action: {
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.Peach)
                            .font(.custom("LexendDeca-Regular", size: 30))
                    }
                    Button(action: {
                    }) {
                        Image(systemName: "x.circle")
                            .foregroundColor(Theme.Peach)
                            .font(.custom("LexendDeca-Regular", size: 30))
                    }
                }
                .listRowBackground(Color.white)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct RequestsPage_Previews: PreviewProvider {
    static var previews: some View {
        RequestsPage()
    }
}
