//
//  RegisterViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

import PhotosUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    
    let registerScreen = RegisterView()
    let storage = Storage.storage()
    var pickedImage:UIImage?
    
    var database: Firestore {
        return Firestore.firestore()
    }
    
    override func loadView() {
        self.view = registerScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerScreen.buttonTakePhoto.menu = getMenuImagePicker()
        var registerButton = registerScreen.registerButton
        registerButton?.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)

    }
    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    func pickUsingCamera(){
           let cameraController = UIImagePickerController()
           cameraController.sourceType = .camera
           cameraController.allowsEditing = true
           cameraController.delegate = self
           present(cameraController, animated: true)
       }
       
       
       func pickPhotoFromGallery(){
           //MARK: Photo from Gallery...
           var configuration = PHPickerConfiguration()
           configuration.filter = PHPickerFilter.any(of: [.images])
           configuration.selectionLimit = 1
           
           let photoPicker = PHPickerViewController(configuration: configuration)
           
           photoPicker.delegate = self
           present(photoPicker, animated: true, completion: nil)
       }
    @objc func registerButtonTapped() {
        let name = registerScreen.nameTextField.text
        let password = registerScreen.passwordTextField.text
        let confirmPassword = registerScreen.confirmPasswordTextField.text
        
        if let uwName = name {
            if(!uwName.isEmpty) {
                if let uwPassword = password {
                    if let uwConfirmPassword = confirmPassword {
                        if(uwPassword == uwConfirmPassword) {
                            uploadProfilePhotoToStorage()
                            
                        }
                        else {
                            showAlert(message: "Passwords do not Match..")
                        }
                    }
                }
            }
            else {
                showAlert(message: "Name Cannot Be Empty")
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
            
          
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
           
            alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

