//
//  ImagePicker.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/10/23.
//

import SwiftUI
import Foundation
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: Image?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary // use PHPicker
        imagePicker.delegate = context.coordinator
            
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator{
        return Coordinator(self)
    }
}


class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            let image = Image(uiImage: uiImage)
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        parent.isPickerShowing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isPickerShowing = false
    }
    
}
