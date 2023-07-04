//
//  FileTypeFunc.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/29/23.
//

import Foundation

func fileType(url: String) -> String? {
    guard let fileExtension = URL(string: url)?.pathExtension.lowercased() else {
        return nil
    }
    
    if fileExtension == "mp4" || fileExtension == "mov" || fileExtension == "avi" {
        return "video"
    } else if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
        return "image"
    } else {
        return nil
    }
}



