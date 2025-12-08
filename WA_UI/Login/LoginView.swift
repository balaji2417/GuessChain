//
//  LoginView.swift
//  WA_UI
//
//  Created by Balaji Sundar on 11/4/25.
//

import UIKit

class LoginView: UIView {
    
    var contentWrapper: UIScrollView!
    var contentView: UIView!
    var mainCard: UIView!
    var loginButton: UIButton!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginLabel: UILabel!
    var registerMessage: UILabel!
    var registerButton: UIButton!
    var logoIcon: UIImageView!
    var logoContainer: UIView!
    
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
        logoIcon.image = UIImage(systemName: "person.circle.fill")
        logoIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        logoIcon.contentMode = .scaleAspectFit
        logoIcon.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.addSubview(logoIcon)
        
        // Login Label
        loginLabel = UILabel()
        loginLabel.text = "Welcome Back"
        loginLabel.font = UIFont(name: "Helvetica-Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold)
        loginLabel.textAlignment = .center
        loginLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(loginLabel)
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Sign in to continue"
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
        
        // Email Field Container
        let emailContainer = createFieldContainer(icon: "envelope.fill", label: "Email")
        mainCard.addSubview(emailContainer)
        emailContainer.tag = 102
        
        emailTextField = createTextField(placeholder: "Enter your email")
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailContainer.addArrangedSubview(emailTextField)
        
        // Password Field Container
        let passwordContainer = createFieldContainer(icon: "lock.fill", label: "Password")
        mainCard.addSubview(passwordContainer)
        passwordContainer.tag = 103
        
        passwordTextField = createTextField(placeholder: "Enter your password")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordContainer.addArrangedSubview(passwordTextField)
        
        // Login Button
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.shadowColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0).cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        loginButton.layer.shadowRadius = 8
        loginButton.layer.shadowOpacity = 0.4
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(loginButton)
        
        // Register Message
        registerMessage = UILabel()
        registerMessage.text = "Don't have an account?"
        registerMessage.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        registerMessage.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        registerMessage.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(registerMessage)
        
        // Register Button
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        registerButton.setTitleColor(UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0), for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(registerButton)
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
              let emailContainer = mainCard.viewWithTag(102),
              let passwordContainer = mainCard.viewWithTag(103) else { return }
        
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
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: contentWrapper.heightAnchor),
            
            // Main Card
            mainCard.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mainCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Logo Container
            logoContainer.topAnchor.constraint(equalTo: mainCard.topAnchor, constant: 32),
            logoContainer.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 90),
            logoContainer.heightAnchor.constraint(equalToConstant: 90),
            
            // Logo Icon
            logoIcon.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoIcon.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 50),
            logoIcon.heightAnchor.constraint(equalToConstant: 50),
            
            // Login Label
            loginLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 20),
            loginLabel.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 6),
            subtitleLabel.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            
            // Divider
            divider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            divider.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Email Container
            emailContainer.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            emailContainer.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            emailContainer.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Password Container
            passwordContainer.topAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 16),
            passwordContainer.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            passwordContainer.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 28),
            loginButton.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Register Message
            registerMessage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerMessage.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor, constant: -30),
            
            // Register Button
            registerButton.centerYAnchor.constraint(equalTo: registerMessage.centerYAnchor),
            registerButton.leadingAnchor.constraint(equalTo: registerMessage.trailingAnchor, constant: 4),
            registerButton.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: -28)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
