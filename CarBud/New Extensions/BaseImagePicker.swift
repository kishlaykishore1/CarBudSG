//
//  BaseImagePicker.swift
//  SweetLifePartner
//
//  Created by angrej singh on 19/11/19.
//  Copyright © 2019 com.tp.sweetlifepartner. All rights reserved.
//

import UIKit
import AVFoundation

class BaseImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let imagePicker = UIImagePickerController()
    var index = 0
    var docTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.delegate = self
        
    }
    
    func openOptions(_ index: Int = 0, _ title: String = "") {
        self.index = index
        self.docTitle = title
        let alert = UIAlertController(title: "Choose Image", message: "Pick Image From : ", preferredStyle: .actionSheet)
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default) { (btn) in
            self.imagePicker.sourceType = .photoLibrary
            self.openPicker()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (btn) in
            
            self.imagePicker.sourceType = .camera
            self.openPicker()
        
    }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(gallaryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
   }
    
    //single image store
    func selectedImage(chooseImage:UIImage) {
        
    }
    
    //multiple image store
    func selectedImageWithIndex(chooseImage:UIImage, index: Int, title: String) {
           
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chooseImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        selectedImage(chooseImage: chooseImage)
        selectedImageWithIndex(chooseImage: chooseImage, index: self.index, title: self.docTitle)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func openPicker()  {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}
