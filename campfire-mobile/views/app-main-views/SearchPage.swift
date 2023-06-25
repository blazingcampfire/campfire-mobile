//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            Text("Search for users") //users collection querey
        }
        .searchable(text: $searchText)
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
