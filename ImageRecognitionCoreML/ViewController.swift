//
//  ViewController.swift
//  ImageRecognitionCoreML
//
//  Created by Kenneth Nagata on 5/14/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // imageView outlet
    @IBOutlet weak var cameraImageView: UIImageView!
    // Create new imagePicker object
    let imagePicker = UIImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the imagepicker
        imagePicker.delegate = self
        // change sourceType = .photoLibrary to allow user to use thier photos instead of camera
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        // Show camera upon loading
        present(imagePicker, animated: true, completion: nil)
    }
    
    // imagePicker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraImageView.image = selectedImage
            guard let ciimage = CIImage(image: selectedImage) else {
                fatalError("Could not convert to CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // Func used to process the image, must have inceptionV3, coreML, and vision.
    func detect(image: CIImage) {
        // Load the model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed.")
        }
        
        // process the image passed in
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            // set the nav bar title to result with highest confidence %
            if let firstResult = results.first {
                self.navigationItem.title = "\(Int(firstResult.confidence*100))%: \(firstResult.identifier)"
            }
        }
        
        // Process the image through Vision
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    // Action for nav bar camera button
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}
