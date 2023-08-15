//
//  IndividualCommentModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/15/23.
//

import SwiftUI
import Firebase


class IndividualComment: ObservableObject {
    @Published var commentItem: Comment
    
    var profilepic: String {
        return commentItem.profilepic
    }
    
    var username: String {
        return commentItem.username
    }
    
    var comment: String {
        return commentItem.comment
    }
    
    var date: Timestamp {
        return commentItem.date
    }
    
    var numLikes: Int {
        return commentItem.numLikes
    }
    
    init(commentItem: Comment) {
        self.commentItem = commentItem
    }
}

class IndividualReply: ObservableObject {
    @Published var replyItem: Reply
    
    var profilepic: String {
        return replyItem.profilepic
    }
    
    var username: String {
        return replyItem.username
    }
    
    var comment: String {
        return replyItem.reply
    }
    
    var date: Timestamp {
        return replyItem.date
    }
    
    var numLikes: Int {
        return replyItem.numLikes
    }
    
    init(replyItem: Reply) {
        self.replyItem = replyItem
    }
    
}
