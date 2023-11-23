//
//  CameraViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 16/11/23.
//

import UIKit
import AVFoundation
import Vision
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.captureSession = AVCaptureSession()
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do{
            let input = try AVCaptureDeviceInput(device: backCamera)
        
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                
                previewLayer.videoGravity = .resizeAspect
                previewLayer.connection?.videoOrientation = .portrait
                self.view.layer.insertSublayer(previewLayer, at: 0)
                self.captureSession.startRunning()
                self.previewLayer.frame = self.view.bounds
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        // Do any additional setup after loading the view.
    }
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!

    @IBAction func takePhotAction(_ sender: Any) {
        print("Taking photo!")
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
         processText(image!)
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        let combinedString = recognizedStrings.joined(separator:" ")
        print(combinedString)
        DBManager.insertIntoNotes(title: "Live Text", content:
        combinedString)
    }
    func processText(_ image: UIImage){
        // Create a new image-request handler.
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)


        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
}
