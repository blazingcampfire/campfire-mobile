//
//  authFunctions.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import FirebaseFirestore
// MARK: - School Functions
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

func reportsParser(school: String) -> CollectionReference? {
    guard let reportsCollection = reportsMap[school] else { return nil }
    return reportsCollection
}

// MARK: - Formatting Functions
func formatNumber(_ number: Int) -> String {
    if number >= 1000 {
        let numberInK = Double(number) / 1000.0
        return String(format: "%.1fk", numberInK)
    } else {
        return String(number)
    }
}



func formatAddress(_ location: String) -> String {
    let locationAddresses = [
        "7 Andrews View Ct, Windsor Mill": "david house",
        "37 High St, New Haven": "Sig Nu Yale",
        "1605 Rice Blvd, Houston" : "McMurtry College",
        "1601 Rice Blvd, Houston" : "Duncan College",
        "9 Sunset Blvd, Houston" : "Brown College",
        "23 Sunset Blvd, Houston" : "Jones College",
        "99 Sunset Blvd, Houston" : "Martel College",
        "6310 Main St, Houston" : "Lovett College",
        "6320 Main St, Houston" : "Baker College",
        "6360 Main St, Houston" : "Sid Richardson College",
        "6340 Main St, Houston" : "Wiess College",
        "6350 Main St, Houston" : "Hanszen College",
    ]
    
    if let place = locationAddresses[location] {
        return place
    } else {
        return location
    }
}

