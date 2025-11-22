//
//  RegisterView.swift
//  WA8_AnandBabu_4467
//
//  Created by Balaji Sundar on 11/4/25.
//

import UIKit

class RegisterView: UIView {


    var backgroundImageView: UIImageView! 
        var contentWrapper: UIScrollView!
        var registerButton : UIButton!
    
        var emailLabel : UILabel!
        var emailTextField : UITextField!
    
        var passwordLabel : UILabel!
        var passwordTextField : UITextField!
    
        var confirmPasswordLabel : UILabel!
        var confirmPasswordTextField : UITextField!
    
        var nameLabel : UILabel!
        var nameTextField : UITextField!
    
        var registerLabel: UILabel!
        
        
        override init(frame: CGRect) {
               super.init(frame: frame)
                self.backgroundColor = .white
            setupBackground()
                setupScrollView()
                setupLabels()
                setupFields()
                initConstraints()
            
           }
    func setupBackground() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "game")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view and send to back
        self.insertSubview(backgroundImageView, at: 0)
    }
    
    
        func setupScrollView() {
            
            contentWrapper = UIScrollView()
            contentWrapper.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(contentWrapper)
            
        }
    
    func setupLabels() {
        
        registerLabel = UILabel()
        registerLabel.text = "Register"
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        contentWrapper.addSubview(registerLabel)
        
        nameLabel = UILabel()
        nameLabel.text = "Name:"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        contentWrapper.addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.setContentHuggingPriority(.required, for: .horizontal)
        emailLabel.text = "Email:"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.boldSystemFont(ofSize: 25)
        contentWrapper.addSubview(emailLabel)
        
        passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.font = UIFont.boldSystemFont(ofSize: 25)
        contentWrapper.addSubview(passwordLabel)
        
        confirmPasswordLabel = UILabel()
        confirmPasswordLabel.text = "Confirm Password:"
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel.font = UIFont.boldSystemFont(ofSize: 25)
        contentWrapper.addSubview(confirmPasswordLabel)
        
        
    }
    
    func setupFields() {
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter your name"
        nameTextField.autocapitalizationType = .none
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameTextField)
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Enter your Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter your Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(passwordTextField)
        
        confirmPasswordTextField = UITextField()
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(confirmPasswordTextField)
        
        registerButton = UIButton()
        registerButton.setTitle( "Register", for: .normal)
        registerButton.layer.cornerRadius = 10
        registerButton.backgroundColor = .systemBlue
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
        
       
    }
        
      
        
        func initConstraints() {
           
                         
                // Activate all constraints in a single block
                NSLayoutConstraint.activate([
                    backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
                     backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                     backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                     backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                     
                    contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                    contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                    contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                    contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

                    // MARK: - Register Label
                    registerLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 150),
                    registerLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

                    // MARK: - Email Row
                    
                    emailLabel.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 50),
                    emailLabel.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),
                   

                    emailTextField.firstBaselineAnchor.constraint(equalTo: emailLabel.firstBaselineAnchor),
                    emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 8),
                    emailTextField.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),

                    // MARK: - Name Row
                    nameLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 25),
                    nameLabel.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),

                    nameTextField.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
                    nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
                    nameTextField.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),
                    
                    
                    // MARK: - Password Row
                    passwordLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
                    passwordLabel.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),

                    passwordTextField.firstBaselineAnchor.constraint(equalTo: passwordLabel.firstBaselineAnchor),
                    passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 8),
                    passwordTextField.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),

                    // MARK: - Confirm Password Row
                    confirmPasswordLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 25),
                    confirmPasswordLabel.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),

                    confirmPasswordTextField.firstBaselineAnchor.constraint(equalTo: confirmPasswordLabel.firstBaselineAnchor),
                    confirmPasswordTextField.leadingAnchor.constraint(equalTo: confirmPasswordLabel.trailingAnchor, constant: 8),
                    confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),
                
                

                    // MARK: - Register Button
                    registerButton.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 45),
                    registerButton.leadingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.leadingAnchor, constant: 8),
                    registerButton.trailingAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.trailingAnchor, constant: -8),
                    registerButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -8),// Give button a standard height
                ])
                
                
                
                
                
                
              
                        
                
        }
        
        
        required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }

    }



