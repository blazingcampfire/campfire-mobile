//
//  schools.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import FirebaseFirestore
import Foundation
// global constant of the three schools campfire will support at launch (as found in .edu emails)
let globalSchools: [String] = ["yale", "rice", "nd"]

// series of maps/dictionaries that will match user to appropriate Firestore collections based on their school
let usersMap: [String: CollectionReference] = [
    "nd": ndUsers,
    "yale": yaleUsers,
    "rice": riceUsers]

let profilesMap: [String: CollectionReference] = [
    "nd": ndProfiles,
    "yale": yaleProfiles,
    "rice": riceProfiles]

let relationshipsMap: [String: CollectionReference] = [
    "nd": ndRelationships,
    "yale": yaleRelationships,
    "rice": riceRelationships]

let postsMap: [String: CollectionReference] = [
    "nd": ndPosts,
    "yale": yalePosts,
    "rice": ricePosts]

let reportsMap: [String: CollectionReference] = [
    "nd": ndReports,
    "yale": yaleReports,
    "rice": riceReports]
