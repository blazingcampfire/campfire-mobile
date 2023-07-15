////
////  VidOrImagePicker.swift
////  campfire-mobile
////
////  Created by Adarsh G on 7/12/23.
////
//
//import SwiftUI
//import Foundation
//import UIKit
//import PhotosUI
//
//struct VidOrImagePicker: UIViewControllerRepresentable {
//    
//    @Binding var selectedImage: Image?
//    @Binding var isPickerShowing: Bool
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        
//        // this function initializes a PHPickerVC object that can be used for users to choose photo library images
//        
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
//        configuration.selectionLimit = 1
//        
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = context.coordinator
//        
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//}
//
//
//class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
//    
//    var parent: VidOrImagePicker
//    
//    init(_ picker: VidOrImagePicker) {
//        self.parent = picker
//    }
//    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        
//        guard let result = results.first else {
//            parent.isPickerShowing = false
//            return
//        }
//        
//        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//            if let error = error {
//                print("Error loading image: \(error.localizedDescription)")
//            } else if let image = image as? UIImage {
//                DispatchQueue.main.async {
//                    self?.parent.selectedImage = Image(uiImage: image)
//                    self?.parent.isPickerShowing = false
//                }
//            } else {
//                print("Unable to load image.")
//            }
//        }
//    }
//    
//    func pickerDidCancel(_ picker: PHPickerViewController) {
//        picker.dismiss(animated: true)
//        parent.isPickerShowing = false
//    }
//    
//}
