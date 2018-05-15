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
        
        
    }
    
    // imagePicker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the image user has selected
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraImageView.image = selectedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

