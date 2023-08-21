




//
//  MediaPicker.swift
//  customcam
//
//  Created by Femi Adebogun on 7/21/23.
//

import SwiftUI
import PhotosUI
import ImageIO
import AVKit
import AVFoundation
import MobileCoreServices



struct MediaPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    @EnvironmentObject var camera: CameraModel

    func makeUIViewController(context: Context) -> UIViewController {
        let picker = PHPickerViewController(configuration: configurePicker())
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Not displaying the image or video, so not needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(camera)
    }

    private func configurePicker() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .videos])

        return configuration
    }

    class Coordinator: PHPickerViewControllerDelegate {
        @ObservedObject var camera: CameraModel

        init(_ camera: CameraModel) {
            self.camera = camera
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)

            guard let itemProvider = results.first?.itemProvider else {
                return
            }

            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            let adjustedImage = self.camera.fixImageOrientation(for: selectedImage)
                            self.camera.selectedImageData = adjustedImage.jpegData(compressionQuality: 0.8)
                        }
                    } else if let error = error {
                       return
                    }
                }
            } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    guard error == nil, let url = url else {
                        return
                    }
                    // Create a new filename for the video
                    let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                    // Create a new URL in the app's temporary directory
                    let newUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                    // Copy the video to the app's temporary directory
                    do {
                        try FileManager.default.copyItem(at: url, to: newUrl)
                        let videoData = try Data(contentsOf: newUrl)
                        DispatchQueue.main.async {
                            self.camera.selectedVideoURL = newUrl // Set the selectedVideoURL in the CameraModel
                            if videoData.count > 12000000 {
                                self.camera.videoTooLarge = true
                                self.camera.videoSizeAlert = true
                            }
                        }
                    } catch {
                        return
                    }
                }
            }
        }
    }
}


