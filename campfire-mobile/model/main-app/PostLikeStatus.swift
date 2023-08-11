//
//  PostLikeStatus.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/10/23.
//

import SwiftUI
import Firebase

class PostLikeStatusModel: ObservableObject {
    @Published var likedStatus = [String: Bool]()
}

class CommentLikeStatusModel: ObservableObject {
    @Published var likedStatus = [String: Bool]()
}

class ReplyLikeStatusModel: ObservableObject {
    @Published var likedStatus = [String: Bool]()
}


