import SwiftUI
import Foundation
import UIKit
import PhotosUI
import TOCropViewController // Import the TOCropViewController module

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> ImageCoordinator {
        Coordinator(self)
    }
}

class ImageCoordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    var parentViewController: UIViewController? // Add a reference to the parent view controller
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else {
            parent.isPickerShowing = false
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else if let image = object as? UIImage { // Check if object is a UIImage
                DispatchQueue.main.async {
                    self?.showCropViewController(with: image)
                }
            } else {
                print("Unable to load image.")
            }
        }
    }
    
    func pickerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true)
        parent.isPickerShowing = false
    }
    
    private func showCropViewController(with image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        parentViewController?.present(cropViewController, animated: true, completion: nil) // Use the parentViewController to present the crop view controller
    }
}

extension ImageCoordinator: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        parent.selectedImage = image
        parent.isPickerShowing = false
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
