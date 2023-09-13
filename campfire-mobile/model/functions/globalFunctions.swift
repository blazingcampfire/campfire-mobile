//
//  authFunctions.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import FirebaseFirestore
import Foundation

// MARK: - School Functions

// function verifies whether a given users email belongs to Yale, ND, or Rice
func schoolValidator(email: String) -> Bool {
    let schools = globalSchools

    for school in schools {
        if email.hasSuffix("@\(school).edu") {
            return true
        }
    }

    return false
}

// similar to schoolValidator, this function returns a user's school based on their email
func schoolParser(email: String) -> String {
    let schools = globalSchools

    for school in schools {
        if email.hasSuffix("@\(school).edu") {
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

func notificationsParser(school: String) -> CollectionReference? {
    guard let notificationsCollection = notificationsMap[school] else { return nil }
    return notificationsCollection
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

func formatAddress(_ location: String, school: String) -> String {
    var univ = school
    switch school {
    case "rice":
        univ = "Rice"
    case "yale":
        univ = "Yale"
    case "nd":
        univ = "Notre Dame"
    default:
        univ = school
    }


    let locationAddresses = [
        "7 Andrews View Ct, Windsor Mill": "david house",
        "37 High St, New Haven": "Sig Nu House Yale",
        "1605 Rice Blvd, Houston": "McMurtry College",
        "1601 Rice Blvd, Houston": "Duncan College",
        "9 Sunset Blvd, Houston": "Brown College",
        "23 Sunset Blvd, Houston": "Jones College",
        "99 Sunset Blvd, Houston": "Martel College",
        "6310 Main St, Houston": "Lovett College",
        "6320 Main St, Houston": "Baker College",
        "6360 Main St, Houston": "Sid Richardson College",
        "6340 Main St, Houston": "Wiess College",
        "6350 Main St, Houston": "Hanszen College",
        "6296 Main St, Houston": "Sewall Hall",
        "19330 S Dining Hall Dr, Notre Dame": "SDH",
        "54655 N Notre Dame Ave, Notre Dame": "South Quad",
        "130 Morris Inn, Notre Dame": "Morris Inn",
        "257 Fitzpatrick Hall, Notre Dame": "Cushing/Fitzpatrick Hall of Engineering",
        "19050 Moose Krause N, Notre Dame": "Debartolo Hall/Duncan Student Center",
        "18991 Moose Krause S, Notre Dame": "Duncan Student Center",
        "284 Hesburgh Library, Notre Dame": "Hesburgh Library",
        "19315 Corby Dr, Notre Dame": "Grotto of Our Lady of Lourdes",
        "1 Eck Center, Notre Dame": "Hammes Notre Dame Bookstore",
        "2010 Moose Krause Cir, Notre Dame": "Notre Dame Stadium",
        "N Notre Dame Ave & Holy Cross Dr, Notre Dame": "Bookstore Basketball Courts",
        "100 Compton Family Ice Arena, Notre Dame": "Compton Family Ice Arena",
        "101 Basilica Drive, Notre Dame": "God Quad",
        "315 LaFortune Student Center, Notre Dame": "LaFun",
        "54261 Wilson Dr, Notre Dame": "West Quad",
        "54570 St Joseph Rd, Notre Dame": "Library Lawn",
        "29 Whalley Ave, New Haven": "Zeta House Yale",
        "35 High St, New Haven": "Leo House Yale",
        "211 Park St, New Haven": "Pierson College",
        "90 Prospect Street, New Haven": "Benjamin Franklin College",
        "130 Prospect St, New Haven": "Pauli Murray College",
        "505 College St, New Haven": "Silliman College",
        "189 Elm St, New Haven": "Grace Hopper College",
        "250 Church St, New Haven": "Berkeley College",
        "242 Elm St, New Haven": "Saybrook College",
        "241 Elm St, New Haven": "Trumbull College",
        "248 York St, New Haven": "Davenport College",
        "68 High St, New Haven": "Jonathan Edwards College",
        "63 High St, New Haven": "Linsly-Chittenden Hall",
        "1035 Chapel St, New Haven": "Vanderbilt Hall",
        "300 College St, New Haven": "Bingham Hall",
        "330 College St, New Haven": "Welch Hall",
        "358 College St, New Haven": "Lawrance Hall",
        "380 College St, New Haven": "Farnam Hall",
        "198 Elm St, New Haven": "Durfee Hall",
        "206 Elm St, New Haven": "Lanman-Wright Hall",
        "345 Temple St, New Haven": "Timothy-Dwight College",
        "302 York St, New Haven": "Ezra Stiles College",
        "304 York St, New Haven": "Morse College",
        "74 High St, New Haven": "Branford College",
        "120 High St, New Haven": "Sterling Memorial Library",
        "300 York St, New Haven": "Toad's Place",
        "15 Broadway, New Haven": "Good Nature Market",
        "260 Whitney Ave, New Haven": "Marsh Lecture Hall",
        "168 Grove St, New Haven": "Schwarzman Center",
        "110 Wall St, New Haven": "Bass Library",
        "242 College St, New Haven": "Insomnia Cookies",
        "265 College St, New Haven": "The Taft Apartments",
        "320 York St, New Haven": "Humanities Quadrangle",
        "35 Whalley Ave, New Haven": "Zeta House Yale",
        "38 Mansfield St, New Haven": "Pauli Murray College",
        "197 York St, New Haven": "Jonathan Edwards College",
        "500 College St, New Haven": "Woosley Hall",
        "109 Wall St, New Haven": "Schwarzman Center",
        "145 High St, New Haven": "The Commons",
        "39 High St, New Haven": "Sig Nu House Yale",
        "100 Wall St, New Haven": "William Harkness Hall"
    ]

    if let place = locationAddresses[location] {
        return ("\(place)" + "📍")
    } else {
        let location = ("\(univ)" + " Campfire 📍")
        return location
    }
}
