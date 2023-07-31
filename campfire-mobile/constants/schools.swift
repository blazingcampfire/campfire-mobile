//
//  schools.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import FirebaseFirestore
// global constant of the three schools campfire will support at launch (as found in .edu emails)
let globalSchools: [String] = ["yale", "rice", "nd"]

let profilesMap: [String: CollectionReference] = [
    "nd": ndProfiles,
    "yale": yaleProfiles,
    "rice": riceProfiles]

let postsMap: [String: CollectionReference] = [
    "nd": ndPosts,
    "yale": yalePosts,
    "rice": ricePosts]

