//
//  ViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    let firstScreen = LoginView()
    var player: Player = Player(name: "", id: "")
    
    override func loadView() {
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        if Auth.auth().currentUser != nil {
            getUserName { [weak self] success in
                DispatchQueue.main.async {
                    if success && !(self?.player.name.isEmpty ?? true) {
                        
                        // User is logged in and has a name, go to Welcome screen
                        self?.navigationController?.setViewControllers([WelcomeViewController()], animated: false)
                    }
                }
            }
        }
        self.view = firstScreen
    }
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        NetworkManager.shared.observe(from: self)
        
        
        var registerButton = firstScreen.registerButton
        registerButton?.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        var loginButton = firstScreen.loginButton
        loginButton?.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func registerButtonTapped() {
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func loginButtonTapped() {
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        if let uwEmail = firstScreen.emailTextField.text {
            if let uwPassword = firstScreen.passwordTextField.text {
                loginApi(uwEmail, uwPassword)
            }
        }
    }

    func navigateToHome() {
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        navigationController?.setViewControllers([WelcomeViewController()], animated: true)
    }
    
    func showError() {
        let alertController = UIAlertController(title: "Error!", message: "Invalid Credentials!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
