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
            Text("")
            NavigationBar()
        }
        .searchable(text: $searchText)
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
