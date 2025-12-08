//
//  LoginApi.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/2/25.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

extension ViewController {
    func loginApi(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if error == nil {
                self.navigateToHome()
            } else {
                if let uwError = error {
                    print(uwError)
                    self.showError()
                }
            }
        })
    }
    
    func getUserName(completion: @escaping (Bool) -> Void) {
        let database = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else {
            print("No User Logged In...")
            completion(false)
            return
        }
        
        database.collection("users").document(currentUser.uid).getDocument(source: .default) { [weak self] document, error in
            guard let self = self else {
                completion(false)
                return
            }
            
            if let error = error {
                print("Failed to get user data: \(error)")
                completion(false)
                return
            }
            
            guard let document = document,
                  document.exists,
                  let data = document.data() else {
                print("Not Found Data")
                completion(false)
                return
            }
            
            self.player.name = data["name"] as? String ?? ""
            self.player.id = document.documentID
            completion(true)
        }
    }
}
