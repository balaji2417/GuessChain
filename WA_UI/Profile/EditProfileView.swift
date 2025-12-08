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
    var streetField: UITextField!
    var cityField: UITextField!
    var zipField: UITextField!
    var mainScrollView: UIScrollView!
    var contentView: UIView!
    var contactCard: UIView!
    var addressCard: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
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
        
        contactCard = UIView()
        contactCard.backgroundColor = .white
        contactCard.layer.cornerRadius = 16
        contactCard.layer.borderWidth = 2
        contactCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        contactCard.layer.shadowColor = UIColor.black.cgColor
        contactCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        contactCard.layer.shadowRadius = 8
        contactCard.layer.shadowOpacity = 0.08
        contactCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactCard)
        
        let contactStack = UIStackView()
        contactStack.axis = .vertical
        contactStack.spacing = 16
        contactStack.translatesAutoresizingMaskIntoConstraints = false
        contactCard.addSubview(contactStack)
        
        let contactHeader = UILabel()
        contactHeader.text = "Contact Information"
        contactHeader.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        contactHeader.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        contactStack.addArrangedSubview(contactHeader)
        
        let divider1 = createDivider()
        contactStack.addArrangedSubview(divider1)
        
        let nameContainer = createFieldContainer(icon: "person.fill", label: "Name")
        contactStack.addArrangedSubview(nameContainer)
        
        nameField = createTextField(placeholder: "Enter your name")
        nameContainer.addArrangedSubview(nameField)

        let emailContainer = createFieldContainer(icon: "envelope.fill", label: "Email")
        contactStack.addArrangedSubview(emailContainer)
        
        emailField = createTextField(placeholder: "Enter your email")
        emailField.keyboardType = .emailAddress
        emailField.isEnabled = false
        emailField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.94, alpha: 1.0)
        emailField.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        emailContainer.addArrangedSubview(emailField)
        
        let phoneContainer = createFieldContainer(icon: "phone.fill", label: "Phone")
        contactStack.addArrangedSubview(phoneContainer)
        
        phoneField = createTextField(placeholder: "Enter your phone number")
        phoneField.keyboardType = .phonePad
        phoneContainer.addArrangedSubview(phoneField)
        
        addressCard = UIView()
        addressCard.backgroundColor = .white
        addressCard.layer.cornerRadius = 16
        addressCard.layer.borderWidth = 2
        addressCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        addressCard.layer.shadowColor = UIColor.black.cgColor
        addressCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        addressCard.layer.shadowRadius = 8
        addressCard.layer.shadowOpacity = 0.08
        addressCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addressCard)
        
        let addressStack = UIStackView()
        addressStack.axis = .vertical
        addressStack.spacing = 16
        addressStack.translatesAutoresizingMaskIntoConstraints = false
        addressCard.addSubview(addressStack)
        
        let addressHeaderStack = UIStackView()
        addressHeaderStack.axis = .horizontal
        addressHeaderStack.spacing = 8
        addressHeaderStack.alignment = .center
        
        let addressIcon = UIImageView()
        addressIcon.image = UIImage(systemName: "location.fill")
        addressIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        addressIcon.contentMode = .scaleAspectFit
        addressIcon.translatesAutoresizingMaskIntoConstraints = false
        addressHeaderStack.addArrangedSubview(addressIcon)
        
        let addressLabel = UILabel()
        addressLabel.text = "Address"
        addressLabel.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        addressLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        addressHeaderStack.addArrangedSubview(addressLabel)
        
        addressStack.addArrangedSubview(addressHeaderStack)
        
        let divider2 = createDivider()
        addressStack.addArrangedSubview(divider2)
        
        let streetContainer = createFieldContainer(icon: "road.lanes", label: "Street")
        addressStack.addArrangedSubview(streetContainer)
        
        streetField = createTextField(placeholder: "Enter street address")
        streetContainer.addArrangedSubview(streetField)
        
        let cityContainer = createFieldContainer(icon: "building.2", label: "City")
        addressStack.addArrangedSubview(cityContainer)
        
        cityField = createTextField(placeholder: "Enter city")
        cityContainer.addArrangedSubview(cityField)
        
        let zipContainer = createFieldContainer(icon: "number", label: "ZIP Code")
        addressStack.addArrangedSubview(zipContainer)
        
        zipField = createTextField(placeholder: "Enter ZIP code")
        zipField.keyboardType = .numberPad
        zipContainer.addArrangedSubview(zipField)
        
        contactStack.tag = 100
        addressStack.tag = 101
        addressIcon.tag = 102
    }
    
    func createFieldContainer(icon: String, label: String) -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(iconView)
        
        let fieldStack = UIStackView()
        fieldStack.axis = .vertical
        fieldStack.spacing = 6
        container.addArrangedSubview(fieldStack)
        
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        fieldStack.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return fieldStack
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        textField.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        textField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.97, alpha: 1.0)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return textField
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }
    
    func setupLayout() {
        guard let contactStack = contactCard.viewWithTag(100),
              let addressStack = addressCard.viewWithTag(101),
              let addressIcon = addressCard.viewWithTag(102) else {
            return
        }
        
        NSLayoutConstraint.activate([

            mainScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            contactCard.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            contactCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactStack.topAnchor.constraint(equalTo: contactCard.topAnchor, constant: 20),
            contactStack.leadingAnchor.constraint(equalTo: contactCard.leadingAnchor, constant: 20),
            contactStack.trailingAnchor.constraint(equalTo: contactCard.trailingAnchor, constant: -20),
            contactStack.bottomAnchor.constraint(equalTo: contactCard.bottomAnchor, constant: -20),
            
            addressCard.topAnchor.constraint(equalTo: contactCard.bottomAnchor, constant: 20),
            addressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            addressStack.topAnchor.constraint(equalTo: addressCard.topAnchor, constant: 20),
            addressStack.leadingAnchor.constraint(equalTo: addressCard.leadingAnchor, constant: 20),
            addressStack.trailingAnchor.constraint(equalTo: addressCard.trailingAnchor, constant: -20),
            addressStack.bottomAnchor.constraint(equalTo: addressCard.bottomAnchor, constant: -20),
            
            addressIcon.widthAnchor.constraint(equalToConstant: 20),
            addressIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
