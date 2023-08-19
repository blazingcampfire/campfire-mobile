//
//  UserInfo.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/25/23.
//

import Foundation
import Firebase
import FirebaseFirestore


let db = Firestore.firestore()
let users = db.collection("users")
let college = users.document("rice")
let profiles = college.collection("profiles")





struct UserInfo {
    var name: String = "David"
    var username: String = "david_adegangbanger"
    var profilepic: String = "ragrboard" // url string
    var chocs: Int = 10
    var bio: String = "I'm him hahwugehfurgfuhiwgfuhfwe"
    var posts: [String] = ["fefef", "jfewjfje", "fjewfjewjf"]
    var email: String = "memellord@hustleruniversity.edu"
    var location: String = "📍 37 High Street"   // likely will have to have some get location function to have a string
}
