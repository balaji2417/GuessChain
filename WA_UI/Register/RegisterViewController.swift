//
//  RegisterViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    let registerScreen = RegisterView()
    
    var database: Firestore {
        return Firestore.firestore()
    }
    
    override func loadView() {
        self.view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        NetworkManager.shared.observe(from: self)
        registerScreen.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerScreen.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc func registerButtonTapped() {
        let name = registerScreen.nameTextField.text
        let email = registerScreen.emailTextField.text
        let password = registerScreen.passwordTextField.text
        let confirmPassword = registerScreen.confirmPasswordTextField.text
        
        // Validate name
        guard let uwName = name, !uwName.isEmpty else {
            showAlert(message: "Name cannot be empty")
            return
        }
        
        // Validate email
        guard let uwEmail = email, !uwEmail.isEmpty else {
            showAlert(message: "Email cannot be empty")
            return
        }
        
        // Validate password
        guard let uwPassword = password, !uwPassword.isEmpty else {
            showAlert(message: "Password cannot be empty")
            return
        }
        
        // Validate confirm password
        guard let uwConfirmPassword = confirmPassword, !uwConfirmPassword.isEmpty else {
            showAlert(message: "Please confirm your password")
            return
        }
        
        // Check passwords match
        if uwPassword != uwConfirmPassword {
            showAlert(message: "Passwords do not match")
            return
        }
        
        // Check password length
        if uwPassword.count < 6 {
            showAlert(message: "Password must be at least 6 characters")
            return
        }
        
        // Proceed with registration
        registerUser(name: uwName, email: uwEmail, password: uwPassword)
    }
    
    func registerUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }
            
            guard let userId = authResult?.user.uid else { return }
            
            // Save user data to Firestore
            self?.database.collection("users").document(userId).setData([
                "name": name,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    self?.showAlert(message: error.localizedDescription)
                    return
                }
                
                // Navigate to welcome screen
                self?.navigateToWelcome()
            }
        }
    }
    
    func navigateToWelcome() {
        let welcomeVC = WelcomeViewController()
        navigationController?.setViewControllers([welcomeVC], animated: true)
    }
    
    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
