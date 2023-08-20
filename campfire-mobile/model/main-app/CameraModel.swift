



//
//  CameraModel.swift
//  customcam
//
//  Created by Femi Adebogun on 7/19/23.
//

import SwiftUI
import AVFoundation
import UIKit
import AVKit
import Combine
import Photos


class CameraModel: NSObject,ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer? = nil
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    @Published var isFlashOn = false
    @Published var movieOutput = AVCaptureMovieFileOutput()
    @Published var isVideoRecorded = false
    @Published var videoPlayback: AVPlayer? = nil
    @Published var progress: Double = 0
    @Published var selectedImageData: Data? = nil
    @Published var selectedVideoURL: URL? = nil
    @Published var selectedMedia: Bool = false
    @Published var flickFlash: AVCaptureDevice.FlashMode = .off
    @Published var isAuthorizationDenied = false
    @Published var isAuthorizationNotDetermined = false
    @Published var zoomFactor: CGFloat = 1.0
    @Published var isSetup = false
    @Published var needtoShowAlert = false
    @Published var sessionInterrupted: Bool = false
    @Published var capturedPic: UIImage?
    @Published var showSelectPhoto: Bool = false
    @Published var showSelectVideo: Bool = false
    @Published var videoTooLarge: Bool = false
    @Published var videoSizeAlert: Bool = false
    
    
    var timer: AnyCancellable?
    var temporaryPhotoURL: URL?
    private var captureDevice: AVCaptureDevice?
    
    //-MARK: Alerts
    enum AlertType: Identifiable {
         case accessDenied, accessNotDetermined, cameraRollAccessDenied, sessionInterrupted
        var id: Int {
               switch self {
               case .accessDenied: return 1
               case .accessNotDetermined: return 2
               case .cameraRollAccessDenied: return 3
               case .sessionInterrupted: return 4
               }
           }
     }
    @Published var alertType: AlertType? = nil
    
  
//-MARK: To Deal With Session Interuptions ex: Facetime calls
    override init() {
       super.init()
        checkCameraPermission()
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted), name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionEnded), name: .AVCaptureSessionInterruptionEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionRuntimeError), name: .AVCaptureSessionRuntimeError, object: nil)
    }
    @objc func sessionWasInterrupted(notification: NSNotification) {
        print("Session was interrupted")
        DispatchQueue.main.async {
            self.alertType = .sessionInterrupted
        }
    }

    @objc func sessionInterruptionEnded(notification: NSNotification) {
        // handle session interruption ended, you can restart your session here
        print("Session interruption ended, attempting to restart session")
        DispatchQueue.main.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
           self.alertType = .sessionInterrupted
        }
    }
    
    @objc func handleSessionRuntimeError(notification: NSNotification) {
        DispatchQueue.main.async {
            self.alertType = .sessionInterrupted
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionRuntimeError, object: nil)
    }

    
    //-MARK: Function to Check for Cam Access
    @objc func checkCameraPermission() {
        self.Check()
    }
   
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setUp()
            print("working")
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                } else {
                    DispatchQueue.main.async {
                        self.alertType = .accessDenied
                    }
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.alertType = .accessDenied
                print("denied access")
                return
            }
        default:
            return
        }
    }
   

    
    //-MARK: Sets up the camera feed/session
    func setUp() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                self.session.beginConfiguration()

                let cameraTypes: [AVCaptureDevice.DeviceType] = [
                    .builtInDualWideCamera,
                    .builtInUltraWideCamera,
                    .builtInDualCamera,
                    .builtInWideAngleCamera
                ]
                if let device = cameraTypes.compactMap({ AVCaptureDevice.default($0, for: .video, position: .back) })
                                           .first(where: { $0.hasTorch }) {
                    let input = try AVCaptureDeviceInput(device: device)
                    if self.session.canAddInput(input) {
                        self.session.addInput(input)
                    }
                } else {
                    print("No suitable camera type found.")
                }

                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }

                if self.session.canAddOutput(self.movieOutput) {
                    self.session.addOutput(self.movieOutput)
                }

                if let audioDevice = AVCaptureDevice.default(for: .audio),
                   let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
                   self.session.canAddInput(audioInput) {
                    self.session.addInput(audioInput)
                }


                self.session.commitConfiguration()

                self.session.startRunning()  // It's crucial to startRunning() on a background thread to prevent blocking the UI.

                DispatchQueue.main.async {
                    self.isSetup = true
                    self.preview = AVCaptureVideoPreviewLayer(session: self.session)

                    let audioSession = AVAudioSession.sharedInstance()
                    NotificationCenter.default.addObserver(self, selector: #selector(self.handleAudioSessionInterruption), name: AVAudioSession.interruptionNotification, object: audioSession)
                }
            } catch {
                print("Oops, something went wrong during camera setup: \(error)")
                print("video error \(error)")
            }
        }
    }
  
    
    @objc func handleAudioSessionInterruption(notification: NSNotification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        switch type {
        case .began:
            // Interruption began, remove audio input
            if let audioInput = session.inputs.first(where: { $0 is AVCaptureDeviceInput && ($0 as! AVCaptureDeviceInput).device.hasMediaType(.audio) }) {
                session.beginConfiguration()
                session.removeInput(audioInput)
                session.commitConfiguration()
            }
        case .ended:
            // Interruption ended, add audio input back
            if let audioDevice = AVCaptureDevice.default(for: .audio),
               let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
               session.canAddInput(audioInput) {
                session.beginConfiguration()
                session.addInput(audioInput)
                session.commitConfiguration()
            }
        default:
            break
        }
    }
    
    //-MARK: Camera Button Actions
    func rotateCamera() {
        DispatchQueue.main.async {
            if let input = self.session.inputs.first as? AVCaptureDeviceInput {
                let newCameraDevice = input.device.position == .back ? self.frontCameraDevice : self.backCameraDevice
                self.session.beginConfiguration()
                self.session.removeInput(input)
                
                if let newDevice = newCameraDevice, let newInput = try? AVCaptureDeviceInput(device: newDevice), self.session.canAddInput(newInput) {
                    self.session.addInput(newInput)
                }
                
                self.session.commitConfiguration()
                
            }
        }
    }

    
    private var frontCameraDevice: AVCaptureDevice? {
        return cameras(with: .front).first
    }
    
    private var backCameraDevice: AVCaptureDevice? {
        return cameras(with: .back).first
    }
    
    private func cameras(with position: AVCaptureDevice.Position) -> [AVCaptureDevice] {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera, .builtInDualCamera],
            mediaType: .video,
            position: .unspecified
        )
        return discoverySession.devices.filter { $0.position == position }
    }
    
    func toggleFlash() {
               isFlashOn.toggle()
               print("Flash is now: \(isFlashOn ? "On" : "OFF")")
           }
    

    func takePic() {
        DispatchQueue.global(qos: .userInitiated).async {
            let settings = AVCapturePhotoSettings()

            // Check if the device supports flash and if it's enabled
            if let device = AVCaptureDevice.default(for: .video), device.isFlashAvailable {
                settings.flashMode = self.isFlashOn ? .on : .off
                print("Taking picture with flash \(settings.flashMode == .on ? "ON" : "OFF")")
            }

            self.output.capturePhoto(with: settings, delegate: self)

            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }


    func fixImageOrientation(for image: UIImage) -> UIImage {
                guard let cgImage = image.cgImage else { return image }

                if image.imageOrientation == .up { return image }

                var transform = CGAffineTransform.identity
                switch image.imageOrientation {
                case .down, .downMirrored:
                    transform = transform.translatedBy(x: image.size.width, y: image.size.height)
                    transform = transform.rotated(by: CGFloat.pi)
                case .left, .leftMirrored:
                    transform = transform.translatedBy(x: image.size.width, y: 0)
                    transform = transform.rotated(by: CGFloat.pi / 2)
                case .right, .rightMirrored:
                    transform = transform.translatedBy(x: 0, y: image.size.height)
                    transform = transform.rotated(by: -CGFloat.pi / 2)
                default:
                    break
                }

                switch image.imageOrientation {
                case .upMirrored, .downMirrored:
                    transform = transform.translatedBy(x: image.size.width, y: 0)
                    transform = transform.scaledBy(x: -1, y: 1)
                case .leftMirrored, .rightMirrored:
                    transform = transform.translatedBy(x: image.size.height, y: 0)
                    transform = transform.scaledBy(x: -1, y: 1)
                default:
                    break
                }

                guard let colorSpace = cgImage.colorSpace,
                      let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height),
                                          bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                          space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
                    return image
                }

                ctx.concatenate(transform)

                switch image.imageOrientation {
                case .left, .leftMirrored, .right, .rightMirrored:
                    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
                default:
                    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                }

                guard let newCGImage = ctx.makeImage() else { return image }
                return UIImage(cgImage: newCGImage)
            }
    


    func reTake() {
            // Perform the session start operation on a background queue
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
                
                guard let device = self.session.inputs.first(where: { $0 is AVCaptureDeviceInput }) as? AVCaptureDeviceInput else {
                    print("Could not find a suitable input device for turning off torch")
                    return
                }
                self.setTorchModeOff(device: device.device)
                // Perform UI updates on the main queue
                DispatchQueue.main.async {
                    withAnimation {
                        self.isSaved = false
                        self.isTaken = false
                        self.isVideoRecorded = false
                        self.picData = Data(count: 0)
                        self.videoPlayback = nil
                        self.progress = 0 // Reset progress
                        self.selectedImageData = nil
                        self.selectedVideoURL = nil
                        self.capturedPic = nil
                        self.showSelectPhoto = false
                        self.showSelectVideo = false
                        self.videoTooLarge = false
                        self.videoSizeAlert = false
                        self.isFlashOn = false
                    }
                }
            }
        }
    
   
    
    func startRecording() {
        print("called startrecord")
        let maxDuration = CMTimeMakeWithSeconds(15, preferredTimescale: 30) // Max duration = 15 seconds
        self.movieOutput.maxRecordedDuration = maxDuration
        
        // Get the camera device and check if it supports video recording.
        guard let device = self.session.inputs.first(where: { $0 is AVCaptureDeviceInput }) as? AVCaptureDeviceInput else {
            print("Could not find a suitable input device for video recording")
            return
        }
            if device.device.isSmoothAutoFocusSupported {
                do {
                    try device.device.lockForConfiguration()
                    device.device.isSmoothAutoFocusEnabled = false
                    setTorchModeOn(device: device.device)
                    device.device.unlockForConfiguration()  // Unlock the configuration
                } catch {
                    print("Could not lock device for configuration: \(error)")
                }
            }
  

        guard let connection = self.output.connection(with: .video) else { return }
        
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait  // or whatever orientation you want to support
        }
        
        let outputDirectory = FileManager.default.temporaryDirectory
        let outputURL = outputDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        
        self.movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        
        DispatchQueue.main.async {
            self.progress = 0
        }
        
        self.timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { _  in
                DispatchQueue.main.async {
                    self.progress += 0.05 / 15 // Increase progress for every fraction of the time
                    if self.progress >= 1.0 {
                        self.progress = 0.0
                        if self.movieOutput.isRecording {
                            self.stopRecording()
                        }
                    }
                }
            }
    }
    
    func setTorchModeOn(device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
            
            if device.hasTorch {
                device.torchMode = isFlashOn ? .on : .off
            } else {
                print("Torch is not available on this device")
            }
            
            device.unlockForConfiguration()
            
        } catch {
            print("Error while locking device for torch configuration: \(error)")
        }
    }
    
    func setTorchModeOff(device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
            
            if device.hasTorch {
                device.torchMode = .off
            } else {
                print("Torch is not available on this device")
            }
            
            device.unlockForConfiguration()
            
        } catch {
            print("Error while locking device for torch configuration: \(error)")
        }
    }

    
    func stopRecording() {
        DispatchQueue.main.async {
        print("called stoprecord")
            self.movieOutput.stopRecording()
            self.timer?.cancel()
            self.timer = nil
        }
    }
    
    //-MARK: Deals with the photo output and saving
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("Error capturing photo: \(error)")
            } else if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
                // Here's the captured photo. You can do something with it now,
                // like save it to your photo library or display it in your UI.
                DispatchQueue.main.async {
                    // Update your UI here with the captured image.
                    let orientImage = self.fixImageOrientation(for: image)
                    self.capturedPic = orientImage
                }
            }
        }


    
    func savePic() {
        print("Attempting to save photo")

        PHPhotoLibrary.requestAuthorization { status in
            print("Photo library authorization status: \(status.rawValue)")
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    if let uiImage = self.capturedPic {
                        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    } else {
                        print("Could not convert data to UIImage")
                    }
                case .denied:
                    self.alertType = .cameraRollAccessDenied
                    print("denied access")
                case .restricted:
                    print("Couldn't save photo: Photo Library access restricted")
                case .notDetermined:
                    self.alertType = .accessNotDetermined
                case .limited:
                    // Handle limited access (optional)
                    print("Limited access to Photo Library")
                @unknown default:
                    print("Unknown authorization status: \(status.rawValue)")
                }
            }
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle error
            print("Couldn't save photo: \(error.localizedDescription)")
        } else {
            self.isSaved = true
            print("Photo saved successfully")
        }
    }


    func saveVideo() {
        guard let videoURL = self.videoPlayback?.currentItem?.asset as? AVURLAsset else {
            print("Couldn't retrieve video URL")
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    PHPhotoLibrary.shared().performChanges {
                        if let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL.url) {
                            request.creationDate = Date()
                        } else {
                            print("Couldnt save video request")
                        }
                    } completionHandler: { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.isSaved = true
                                print("Video saved successfully")
                            } else {
                                print("Couldn't save video: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    }
                case .denied:
                    self.alertType = .cameraRollAccessDenied
                    print("denied access")
                case .restricted:
                    print("Couldn't save video: Photo Library access restricted")
                case .notDetermined:
                    self.alertType = .accessNotDetermined
                case .limited:
                    // Handle limited access (optional)
                    print("Limited access to Photo Library")
                @unknown default:
                    print("Unknown authorization status: \(status.rawValue)")
                }
            }
        }
    }

    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.videoPlayback = AVPlayer(url: outputFileURL)
            self.isVideoRecorded = true
        }
        
        
        if let error = error {
            print("Error while recording: \(error.localizedDescription)")
        } else {
            print("movie success capture: \(outputFileURL)")
        }
    }
    
    
    
    func focus(at devicePoint: CGPoint) {
        let cameraTypes: [AVCaptureDevice.DeviceType] = [
            .builtInDualWideCamera,
            .builtInUltraWideCamera,
            .builtInDualCamera,
            .builtInWideAngleCamera
        ]

        let device = cameraTypes.compactMap {
            AVCaptureDevice.default($0, for: .video, position: .back)
        }.first

        guard let device = device,
              device.isFocusPointOfInterestSupported,
              device.isExposurePointOfInterestSupported,
              device.isFocusModeSupported(.autoFocus),
              device.isExposureModeSupported(.continuousAutoExposure)
        else { return }

        do {
            try device.lockForConfiguration()

            device.focusPointOfInterest = devicePoint
            device.focusMode = .autoFocus

            device.exposurePointOfInterest = devicePoint
            device.exposureMode = .continuousAutoExposure

            device.unlockForConfiguration()
        } catch {
            print("Error occurred while focusing: \(error.localizedDescription)")
        }
    }

}

//-MARK: The View After Photo or Video Taken
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        view.addGestureRecognizer(pinch)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
            view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)

        
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(camera)
    }
    

    func updateUIView(_ uiView: UIView, context: Context) {
          uiView.layer.sublayers?
              .filter { $0 is AVCaptureVideoPreviewLayer }
              .forEach { $0.removeFromSuperlayer() }
          
          if camera.isSetup {
              guard let preview = camera.preview else { return }
              preview.frame = uiView.bounds
              preview.videoGravity = .resizeAspectFill
              uiView.layer.addSublayer(preview)
          }
      }
    
    class Coordinator: NSObject {
        var camera: CameraModel

        init(_ camera: CameraModel) {
            self.camera = camera
        }

        @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
            guard let device = (self.camera.session.inputs.compactMap { $0 as? AVCaptureDeviceInput }.first(where: { $0.device.hasMediaType(.video) }))?.device else {
                return
            }
                    if sender.state == .changed {
                        let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
                        let pinchVelocityDividerFactor: CGFloat = 20.0

                        do {
                            try device.lockForConfiguration()
                            defer { device.unlockForConfiguration() }

                            let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
                            if desiredZoomFactor >= device.minAvailableVideoZoomFactor && desiredZoomFactor <= maxZoomFactor {
                                device.videoZoomFactor = desiredZoomFactor
                            }
                        } catch {
                            print("Error while trying to zoom: \(error.localizedDescription)")
                        }
                    }
                }
        
        @objc func handlePan(_ sender: UIPanGestureRecognizer) {
                    if sender.state == .changed {
                        let velocity = sender.velocity(in: sender.view)
                        // only take action on vertical movement
                        if abs(velocity.y) > abs(velocity.x) {
                            adjustZoom(for: velocity.y)
                        }
                    }
                }
                func adjustZoom(for velocity: CGFloat) {
                     guard let device = (self.camera.session.inputs.compactMap { $0 as? AVCaptureDeviceInput }.first(where: { $0.device.hasMediaType(.video) }))?.device else {
                         return
                     }
                     do {
                         try device.lockForConfiguration()
                         defer { device.unlockForConfiguration() }
                         // velocity is inverted so downswipe increases the zoom
                         let zoomFactor = min(max(1.0, device.videoZoomFactor - velocity / 2000.0), device.activeFormat.videoMaxZoomFactor)
                         device.videoZoomFactor = zoomFactor
                     } catch {
                         print("Error while trying to zoom: \(error.localizedDescription)")
                     }
                 }

        @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
            if sender.state == .ended {
                self.camera.rotateCamera()
            }
        }
        @objc func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
            // Normalize the tapped location to coordinate system of 1x1.
            let locationInView = tapGestureRecognizer.location(in: tapGestureRecognizer.view)
            let normalizedLocation = CGPoint(
                x: locationInView.x / tapGestureRecognizer.view!.bounds.width,
                y: locationInView.y / tapGestureRecognizer.view!.bounds.height)
            camera.focus(at: normalizedLocation)
        }
    }
}



