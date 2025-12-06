//
//  EditProfileView.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 12/5/25.
//

import UIKit

class EditProfileView: UIView {
    
    var nameField: UITextField!
    var emailField: UITextField!
    var phoneField: UITextField!
    var buttonPhoneType: UIButton!
    var streetField: UITextField!
    var cityField: UITextField!
    var zipField: UITextField!
    var mainScrollView: UIScrollView!
    var contentView: UIView!
    var mainStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainScrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(contentView)
        
        
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 12
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
        
        nameField = createTextField(placeholder: "Name")
        mainStackView.addArrangedSubview(nameField)
        
        emailField = createTextField(placeholder: "Email")
        emailField.keyboardType = .emailAddress
        mainStackView.addArrangedSubview(emailField)
        
        let phoneStack = UIStackView()
        phoneStack.axis = .horizontal
        phoneStack.spacing = 8
        phoneStack.translatesAutoresizingMaskIntoConstraints = false
        
        phoneField = createTextField(placeholder: "Phone")
        phoneField.keyboardType = .phonePad
        phoneStack.addArrangedSubview(phoneField)
        
        buttonPhoneType = UIButton(type: .system)
        buttonPhoneType.setTitle("Cell", for: .normal)
        buttonPhoneType.translatesAutoresizingMaskIntoConstraints = false
        phoneStack.addArrangedSubview(buttonPhoneType)
        
        mainStackView.addArrangedSubview(phoneStack)
        
        mainStackView.setCustomSpacing(24, after: phoneStack)
        
        let addressLabel = UILabel()
        addressLabel.text = "Address:"
        addressLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        mainStackView.addArrangedSubview(addressLabel)
        
        streetField = createTextField(placeholder: "Street")
        mainStackView.addArrangedSubview(streetField)
        
        cityField = createTextField(placeholder: "City")
        mainStackView.addArrangedSubview(cityField)
        
        zipField = createTextField(placeholder: "ZIP Code")
        zipField.keyboardType = .numberPad
        mainStackView.addArrangedSubview(zipField)
    }
    
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            nameField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            emailField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            streetField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            cityField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            zipField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            buttonPhoneType.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
