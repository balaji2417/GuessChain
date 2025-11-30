//
//  RegisterFirebaseManager.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/30/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

extension RegisterViewController {
    
    func uploadProfilePhotoToStorage() {
        var profilePhotoURL: URL?
        
        if let image = pickedImage {
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesUsers")
                let imageRef = imagesRepo.child("\(UUID().uuidString).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: { (metadata, error) in
                    if error == nil {
                        imageRef.downloadURL(completion: { (url, error) in
                            if error == nil {
                                profilePhotoURL = url
                                self.registerUser(photoURL: profilePhotoURL)
                            } else {
                                print("Error getting download URL: \(String(describing: error))")
                                self.registerUser(photoURL: nil)
                            }
                        })
                    } else {
                        print("Error uploading image: \(String(describing: error))")
                        // Still register even if photo upload fails
                        self.registerUser(photoURL: nil)
                    }
                })
            }
        } else {
            registerUser(photoURL: nil)
        }
    }
    
    func registerUser(photoURL: URL?) {
        if let name = registerScreen.nameTextField.text,
           let email = registerScreen.emailTextField.text,
           let password = registerScreen.passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                if error == nil {
                    
                    guard let newUserID = result?.user.uid else {
                        print("Error: User was created but we could not get their UID.")
                        return
                    }
                    
                    // Pass name, email, uid, AND photoURL to save function
                    self.saveUserToFirestore(name: name, email: email, uid: newUserID, photoURL: photoURL)
                    
                } else {
                    print("Error creating user: \(String(describing: error))")
                    if let error = error {
                        let nsError = error as NSError
                        if let authError = AuthErrorCode(rawValue: nsError.code) {
                            print("Auth Error Code: \(authError)")
                        }
                    }
                }
            })
        }
    }

    func saveUserToFirestore(name: String, email: String, uid: String, photoURL: URL?) {
        
        // 1. Create the Auth Profile update request
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                print("Error updating Auth profile: \(String(describing: error))")
            }
            
            // 2. Create user data for Firestore
            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "avatarURL": photoURL?.absoluteString ?? ""
            ]
            
            // 3. Save the document to Firestore using the UID
            let userDocument = Firestore.firestore().collection("users")
                                .document(uid)
            
            userDocument.setData(userData) { (error) in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                    
                    // Success! Go back to the login screen.
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
}
