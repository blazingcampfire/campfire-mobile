//
//  unallowedCharacters.swift
//  campfire-mobile
//
//  Created by Adarsh G on 8/7/23.
//

import Foundation

let usernameIllegalChar = ["!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "`", "{", "|", "}", "~", " ", "'", ""]
let nameIllegalChar = ["!", "\u{0022}", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "`", "{", "|", "}", "~", "_", "'", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", " "]


//
//func sendNotification(to fcmToken: String, title: String, body: String) {
//    let urlString = "https://fcm.googleapis.com/fcm/send"
//    let url = URL(string: urlString)!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("YOUR_SERVER_KEY", forHTTPHeaderField: "Authorization")
//
//    let message: [String: Any] = [
//        "to": fcmToken,
//        "notification": [
//            "title": title,
//            "body": body
//        ]
//    ]
//
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error sending notification: \(error)")
//            } else {
//                print("Notification sent successfully")
//            }
//        }.resume()
//    } catch {
//        print("Error creating JSON data: \(error)")
//    }
//}
