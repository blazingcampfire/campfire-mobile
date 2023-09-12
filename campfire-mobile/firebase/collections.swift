//
//  collections.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

let db = Firestore.firestore()
// MARK: - Schools (Document)

let notreDame = db.collection("users").document("notreDame")
let yale = db.collection("users").document("yale")
let rice = db.collection("users").document("rice")

// MARK: - Users (Collection)

let ndUsers = notreDame.collection("users")
let yaleUsers = yale.collection("users")
let riceUsers = rice.collection("users")

// MARK: - Profiles (Collection)

let ndProfiles = notreDame.collection("profiles")
let yaleProfiles = yale.collection("profiles")
let riceProfiles = rice.collection("profiles")

// MARK: - Relationships (Collection)

let ndRelationships = db.collection("relationships").document("notreDame").collection("relationships")
let yaleRelationships = db.collection("relationships").document("yale").collection("relationships")
let riceRelationships = db.collection("relationships").document("rice").collection("relationships")

// MARK: - Feed Posts (Collection)

let ndPosts = notreDame.collection("posts")
let yalePosts = yale.collection("posts")
let ricePosts = rice.collection("posts")

// MARK: - Reports (Collection)

let ndReports = notreDame.collection("reports")
let yaleReports = yale.collection("reports")
let riceReports = rice.collection("reports")

// MARK: - Notifications (Collection)

let ndNotifications = db.collection("notifications").document("notreDame").collection("fcmTokens")
let yaleNotifications = db.collection("notifications").document("yale").collection("fcmTokens")
let riceNotifications = db.collection("notifications").document("rice").collection("fcmTokens")
