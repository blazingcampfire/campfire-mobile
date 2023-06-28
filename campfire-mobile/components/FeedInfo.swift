//
//  FeedInfo.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/26/23.
//

import Foundation
import MapKit

let posterInfo = UserInfo()


struct FeedInfo {
    var postername = UserInfo().username
    var posterpic = UserInfo().profilepic
    var postcaption: String = ""
    var likecount: Int = 10
    var commentnum: Int = 19
    var comments: [String] = ["",""]
 //   var location: CLLocation //Not exactly sure how it collects the location, need to translate to name/string
    var comlikecount: Int = 10
    
}
