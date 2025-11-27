//
//  LoginView.swift
//  WA8_AnandBabu_4467
//
//  Created by Balaji Sundar on 11/4/25.
//

import UIKit

class LoginView: UIView {
     

    var contentWrapper: UIScrollView!
    var loginButton : UIButton!
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var loginLabel: UILabel!
    var registerMessage : UILabel!
    var registerButton : UIButton!
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
// <-- ADDED
        setupScrollView()
        setupFields()
        setupRegisterField()
        initConstraints()
        
    }
    
   
     
    func setupScrollView() {
        
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
         
    }
     
    func setupFields() {
        loginLabel = UILabel()
        loginLabel.text = "Login"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.font = UIFont.boldSystemFont(ofSize: 40)
        // Make text white to be visible on a dark background (optional)
        // loginLabel.textColor = .white
        contentWrapper.addSubview(loginLabel)
         
     
         
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)

         
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(passwordTextField)

         
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(loginButton)

    }
     
    func setupRegisterField() {
        registerMessage = UILabel()
        registerMessage.text = "New here? Click below"
        registerMessage.translatesAutoresizingMaskIntoConstraints = false
        registerMessage.font = UIFont.boldSystemFont(ofSize: 17)
        // Make text white to be visible on a dark background (optional)
        // registerMessage.textColor = .white
        contentWrapper.addSubview(registerMessage)
         
        registerButton = UIButton(type:.system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
         
         
    }
     
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            // <-- ADDED CONSTRAINTS FOR BACKGROUND -->
           
            // Your existing constraints
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
             
             
            loginLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 150),
            loginLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
             
            emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 25),
            emailTextField.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),
                       
            
            //MARK: textField2 constraints...
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),
                       
            
            //MARK: textField3 constraints...
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),
            loginButton.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),
           
             
            registerMessage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerMessage.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
             
            registerButton.topAnchor.constraint(equalTo: registerMessage.bottomAnchor, constant: 5),
            registerButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -8),
                       
             
                 ])
    }
     
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

}
