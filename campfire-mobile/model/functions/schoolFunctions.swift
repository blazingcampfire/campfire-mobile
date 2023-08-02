//
//  authFunctions.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import FirebaseFirestore
// function verifies whether a given users email belongs to Yale, ND, or Rice
func schoolValidator(email: String) -> Bool {
    
    let schools = globalSchools
    
    for school in schools {
        if email.hasSuffix("@\(school).edu")
        {
            return true
        }
    }
    
    return false
}
// similar to schoolValidator, this function returns a user's school based on their email
func schoolParser(email: String) -> String {
    
    let schools = globalSchools
    
    for school in schools {
        if email.hasSuffix("@\(school).edu")
        {
            return school
        }
    }
   return "Does not belong to a supported school"
}
func userParser(school: String) -> CollectionReference? {
    guard let userCollection = usersMap[school] else { return nil }
    return userCollection
}

func profileParser(school: String) -> CollectionReference? {
    guard let profileCollection = profilesMap[school] else { return nil }
    return profileCollection
}

func relationshipsParser(school: String) -> CollectionReference? {
    guard let relationshipsCollection = relationshipsMap[school] else { return nil }
    return relationshipsCollection
}

func postsParser(school: String) -> CollectionReference? {
    guard let postCollection = postsMap[school] else { return nil }
    return postCollection
}



