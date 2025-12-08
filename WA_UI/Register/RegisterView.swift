//
//  RegisterView.swift
//  WA_UI
//
//  Created by Balaji Sundar on 11/4/25.
//

import UIKit

class RegisterView: UIView {
    
    var contentWrapper: UIScrollView!
    var contentView: UIView!
    var mainCard: UIView!
    var registerButton: UIButton!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var nameTextField: UITextField!
    var registerLabel: UILabel!
    var logoIcon: UIImageView!
    var logoContainer: UIView!
    var loginMessage: UILabel!
    var loginButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupViews()
        initConstraints()
    }
    
    func setupViews() {
        // Scroll View
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(contentView)
        
        // Main Card
        mainCard = UIView()
        mainCard.backgroundColor = .white
        mainCard.layer.cornerRadius = 24
        mainCard.layer.borderWidth = 2
        mainCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        mainCard.layer.shadowColor = UIColor.black.cgColor
        mainCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainCard.layer.shadowRadius = 12
        mainCard.layer.shadowOpacity = 0.1
        mainCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainCard)
        
        // Logo Container
        logoContainer = UIView()
        logoContainer.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 0.15)
        logoContainer.layer.cornerRadius = 45
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(logoContainer)
        
        // Logo Icon
        logoIcon = UIImageView()
        logoIcon.image = UIImage(systemName: "person.badge.plus")
        logoIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        logoIcon.contentMode = .scaleAspectFit
        logoIcon.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.addSubview(logoIcon)
        
        // Register Label
        registerLabel = UILabel()
        registerLabel.text = "Create Account"
        registerLabel.font = UIFont(name: "Helvetica-Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold)
        registerLabel.textAlignment = .center
        registerLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(registerLabel)
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Join us to start playing"
        subtitleLabel.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(subtitleLabel)
        subtitleLabel.tag = 100
        
        // Divider
        let divider = createDivider()
        mainCard.addSubview(divider)
        divider.tag = 101
        
        // Name Field Container
        let nameContainer = createFieldContainer(icon: "person.fill", label: "Name")
        mainCard.addSubview(nameContainer)
        nameContainer.tag = 102
        
        nameTextField = createTextField(placeholder: "Enter your name")
        nameTextField.autocapitalizationType = .words
        nameContainer.addArrangedSubview(nameTextField)
        
        // Email Field Container
        let emailContainer = createFieldContainer(icon: "envelope.fill", label: "Email")
        mainCard.addSubview(emailContainer)
        emailContainer.tag = 103
        
        emailTextField = createTextField(placeholder: "Enter your email")
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailContainer.addArrangedSubview(emailTextField)
        
        // Password Field Container
        let passwordContainer = createFieldContainer(icon: "lock.fill", label: "Password")
        mainCard.addSubview(passwordContainer)
        passwordContainer.tag = 104
        
        passwordTextField = createTextField(placeholder: "Enter your password")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordContainer.addArrangedSubview(passwordTextField)
        
        // Confirm Password Field Container
        let confirmPasswordContainer = createFieldContainer(icon: "lock.shield.fill", label: "Confirm Password")
        mainCard.addSubview(confirmPasswordContainer)
        confirmPasswordContainer.tag = 105
        
        confirmPasswordTextField = createTextField(placeholder: "Confirm your password")
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordContainer.addArrangedSubview(confirmPasswordTextField)
        
        // Register Button
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        registerButton.layer.cornerRadius = 12
        registerButton.layer.shadowColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0).cgColor
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        registerButton.layer.shadowRadius = 8
        registerButton.layer.shadowOpacity = 0.4
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(registerButton)
        
        // Login Message
        loginMessage = UILabel()
        loginMessage.text = "Already have an account?"
        loginMessage.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        loginMessage.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        loginMessage.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(loginMessage)
        
        // Login Button
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        loginButton.setTitleColor(UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0), for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(loginButton)
    }
    
    func createFieldContainer(icon: String, label: String) -> UIStackView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        headerStack.addArrangedSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        headerStack.addArrangedSubview(titleLabel)
        
        container.addArrangedSubview(headerStack)
        
        return container
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        textField.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.97, alpha: 1.0)
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        textField.rightViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return textField
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }
    
    func initConstraints() {
        guard let subtitleLabel = mainCard.viewWithTag(100),
              let divider = mainCard.viewWithTag(101),
              let nameContainer = mainCard.viewWithTag(102),
              let emailContainer = mainCard.viewWithTag(103),
              let passwordContainer = mainCard.viewWithTag(104),
              let confirmPasswordContainer = mainCard.viewWithTag(105) else { return }
        
        NSLayoutConstraint.activate([
            // Scroll View
            contentWrapper.topAnchor.constraint(equalTo: self.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: contentWrapper.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor),
            
            // Main Card
            mainCard.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mainCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Logo Container
            logoContainer.topAnchor.constraint(equalTo: mainCard.topAnchor, constant: 28),
            logoContainer.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 90),
            logoContainer.heightAnchor.constraint(equalToConstant: 90),
            
            // Logo Icon
            logoIcon.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoIcon.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 45),
            logoIcon.heightAnchor.constraint(equalToConstant: 45),
            
            // Register Label
            registerLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 16),
            registerLabel.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 6),
            subtitleLabel.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            
            // Divider
            divider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            divider.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Name Container
            nameContainer.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            nameContainer.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            nameContainer.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Email Container
            emailContainer.topAnchor.constraint(equalTo: nameContainer.bottomAnchor, constant: 14),
            emailContainer.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            emailContainer.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Password Container
            passwordContainer.topAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 14),
            passwordContainer.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            passwordContainer.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Confirm Password Container
            confirmPasswordContainer.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 14),
            confirmPasswordContainer.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            confirmPasswordContainer.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Register Button
            registerButton.topAnchor.constraint(equalTo: confirmPasswordContainer.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Login Message
            loginMessage.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            loginMessage.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor, constant: -20),
            
            // Login Button
            loginButton.centerYAnchor.constraint(equalTo: loginMessage.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: loginMessage.trailingAnchor, constant: 4),
            loginButton.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
