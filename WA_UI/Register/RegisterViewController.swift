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
    
    var database: Firestore {
        return Firestore.firestore()
    }
    
    override func loadView() {
        self.view = registerScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var registerButton = registerScreen.registerButton
        registerButton?.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)

    }
    
    @objc func registerButtonTapped() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
    

}
