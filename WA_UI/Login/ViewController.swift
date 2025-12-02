//
//  ViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

class ViewController: UIViewController {
    let firstScreen = LoginView()
    
    override func loadView() {
        self.view = firstScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var registerButton = firstScreen.registerButton
        registerButton?.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        var loginButton = firstScreen.loginButton
        loginButton?.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func registerButtonTapped() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func loginButtonTapped() {
        if let uwEmail = firstScreen.emailTextField.text {
            if let uwPassword = firstScreen.passwordTextField.text {
                loginApi(uwEmail,uwPassword)
            }
        }
    }

    func navigateToHome(){
        navigationController?.pushViewController(WelcomeViewController(), animated: true)
    }
    
    func showError(){
        let alertController = UIAlertController(title: "Error!", message: "Invalid Credentials!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
