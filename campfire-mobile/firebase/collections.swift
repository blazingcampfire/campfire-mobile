//
//  collections.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

//let db = Firestore.firestore()

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

//MARK: - Relationships (Collection)
let ndRelationships = notreDame.collection("relationships")
let yaleRelationships = yale.collection("relationships")
let riceProfiles = rice.collection("relationships")


