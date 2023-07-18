//
//  collections.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

let db = Firestore.firestore()

let notreDame = db.collection("notre-dame")
let rice = db.collection("rice")
let yale = db.collection("yale")

