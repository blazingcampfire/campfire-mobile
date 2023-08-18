//
//  misc.swift
//  campfire-mobile
//
//  Created by Toni on 8/8/23.
//

import Foundation

let emptyCurrentUser = CurrentUserModel(privateUserData: PrivateUser(phoneNumber: "", email: "", userID: "", school: ""), profile: Profile(name: "", nameInsensitive: "", phoneNumber: "", email: "", username: "", posts: [], smores: 0, profilePicURL: "", userID: "", school: "", bio: ""), userRef: ndUsers, profileRef: ndProfiles, relationshipsRef: ndRelationships, postsRef: ndPosts)
