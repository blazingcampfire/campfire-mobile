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

// MARK: - Schools
let notreDame = db.collection("users").document("notreDame")
let yale = db.collection("users").document("yale")
let rice = db.collection("users").document("rice")

// MARK: - Profiles
let ndProfiles = notreDame.collection("profiles")
let yaleProfiles = yale.collection("profiles")
let riceProfiles = rice.collection("profiles")
