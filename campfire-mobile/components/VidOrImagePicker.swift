////
////  VidOrImagePicker.swift
////  campfire-mobile
////
////  Created by Adarsh G on 7/15/23.
////
//
//import SwiftUI
//import PhotosUI
//
//
//struct MediaPickerView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let picker = PHPickerViewController(configuration: configurePicker())
//        picker.delegate = context.coordinator
//
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        // No update needed
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    private func configurePicker() -> PHPickerConfiguration {
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 1
//
//        return configuration
//    }
//
//    class Coordinator: PHPickerViewControllerDelegate {
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true, completion: nil)
//
//            guard let itemProvider = results.first?.itemProvider else {
//                return
//            }
//
//            if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                    if let selectedImage = image as? UIImage {
//                        // Do something with the selected image
//                        print("Selected image: \(selectedImage)")
//                    } else if let error = error {
//                        print("Failed to load image: \(error.localizedDescription)")
//                    }
//                }
//            } else if itemProvider.canLoadObject(ofClass: URL.self) {
//                itemProvider.loadObject(ofClass: URL.self) { url, error in
//                    if let selectedURL = url {
//                        // Do something with the selected URL (video)
//                        print("Selected video URL: \(selectedURL)")
//                    } else if let error = error {
//                        print("Failed to load video URL: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//}
