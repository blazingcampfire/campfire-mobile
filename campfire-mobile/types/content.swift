//
//  content.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation

struct Post: Codable, Hashable, Identifiable {
    var id = UUID()
    let post: [Data: String]
}
