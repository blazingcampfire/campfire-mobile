//
//  authFunctions.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation

// function verifies whether a given users email belongs to Yale, ND, or Rice
func schoolValidator(email: String) -> Bool {
    
    let schools = globalSchools
    
    for school in schools {
        if email.contains(school)
        {
            return true
        }
    }
    
    return false
}
