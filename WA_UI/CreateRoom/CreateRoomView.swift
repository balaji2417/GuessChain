//
//  CreateRoomView.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class CreateRoomView: UIView {
    
    var labelTitle: UILabel!
    var textFieldRoomName: UITextField!
    var buttonCreate: UIButton!
    var buttonCancel: UIButton!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var mainCard: UIView!
    var mainStack: UIStackView!
    var headerIcon: UIImageView!
    var fieldContainer: UIStackView!
    var buttonsStack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupViews()
        initConstraints()
    }
    
    func setupViews() {
        // Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Main Card
        mainCard = UIView()
        mainCard.backgroundColor = .white
        mainCard.layer.cornerRadius = 16
        mainCard.layer.borderWidth = 2
        mainCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        mainCard.layer.shadowColor = UIColor.black.cgColor
        mainCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainCard.layer.shadowRadius = 8
        mainCard.layer.shadowOpacity = 0.08
        mainCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainCard)
        
        // Main Stack
        mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(mainStack)
        
        // Header Icon
        headerIcon = UIImageView()
        headerIcon.image = UIImage(systemName: "plus.rectangle.fill")
        headerIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        headerIcon.contentMode = .scaleAspectFit
        headerIcon.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(headerIcon)
        
        // Title
        labelTitle = UILabel()
        labelTitle.text = "Create Room"
        labelTitle.font = UIFont(name: "Helvetica-Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold)
        labelTitle.textAlignment = .center
        labelTitle.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        mainStack.addArrangedSubview(labelTitle)
        
        // Divider
        let divider = createDivider()
        mainStack.addArrangedSubview(divider)
        
        // Room Name Field Container
        fieldContainer = UIStackView()
        fieldContainer.axis = .vertical
        fieldContainer.spacing = 8
        fieldContainer.alignment = .leading
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(fieldContainer)
        
        // Field Header
        let fieldHeaderStack = UIStackView()
        fieldHeaderStack.axis = .horizontal
        fieldHeaderStack.spacing = 8
        fieldHeaderStack.alignment = .center
        
        let fieldIcon = UIImageView()
        fieldIcon.image = UIImage(systemName: "tag.fill")
        fieldIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        fieldIcon.contentMode = .scaleAspectFit
        fieldIcon.translatesAutoresizingMaskIntoConstraints = false
        fieldHeaderStack.addArrangedSubview(fieldIcon)
        
        let fieldLabel = UILabel()
        fieldLabel.text = "Room Name"
        fieldLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        fieldLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        fieldHeaderStack.addArrangedSubview(fieldLabel)
        
        fieldContainer.addArrangedSubview(fieldHeaderStack)
        
        // Text Field
        textFieldRoomName = UITextField()
        textFieldRoomName.placeholder = "Enter room name"
        textFieldRoomName.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        textFieldRoomName.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        textFieldRoomName.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.97, alpha: 1.0)
        textFieldRoomName.layer.cornerRadius = 8
        textFieldRoomName.layer.borderWidth = 1
        textFieldRoomName.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        textFieldRoomName.translatesAutoresizingMaskIntoConstraints = false
        textFieldRoomName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textFieldRoomName.leftViewMode = .always
        textFieldRoomName.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textFieldRoomName.rightViewMode = .always
        fieldContainer.addArrangedSubview(textFieldRoomName)
        
        // Buttons Stack
        buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 12
        buttonsStack.alignment = .fill
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(buttonsStack)
        
        // Create Button
        buttonCreate = UIButton(type: .system)
        buttonCreate.setTitle("Create Room", for: .normal)
        buttonCreate.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        buttonCreate.setTitleColor(.white, for: .normal)
        buttonCreate.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        buttonCreate.layer.cornerRadius = 12
        buttonCreate.translatesAutoresizingMaskIntoConstraints = false
        
        let createIcon = UIImage(systemName: "checkmark.circle.fill")
        buttonCreate.setImage(createIcon, for: .normal)
        buttonCreate.tintColor = .white
        buttonCreate.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        buttonsStack.addArrangedSubview(buttonCreate)
        
        // Cancel Button
        buttonCancel = UIButton(type: .system)
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.titleLabel?.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        buttonCancel.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), for: .normal)
        buttonCancel.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.97, alpha: 1.0)
        buttonCancel.layer.cornerRadius = 12
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.addArrangedSubview(buttonCancel)
        
        // Store tag for divider
        divider.tag = 102
        fieldIcon.tag = 104
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }
    
    func initConstraints() {
        guard let divider = mainCard.viewWithTag(102),
              let fieldIcon = fieldContainer.viewWithTag(104) else { return }
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Main Card
            mainCard.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            // Main Stack
            mainStack.topAnchor.constraint(equalTo: mainCard.topAnchor, constant: 30),
            mainStack.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: -30),
            
            // Header Icon
            headerIcon.widthAnchor.constraint(equalToConstant: 50),
            headerIcon.heightAnchor.constraint(equalToConstant: 50),
            
            // Divider
            divider.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            // Field Container
            fieldContainer.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            fieldContainer.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            // Field Icon
            fieldIcon.widthAnchor.constraint(equalToConstant: 20),
            fieldIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // Text Field
            textFieldRoomName.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            textFieldRoomName.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            textFieldRoomName.heightAnchor.constraint(equalToConstant: 48),
            
            // Buttons Stack
            buttonsStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            // Button Heights
            buttonCreate.heightAnchor.constraint(equalToConstant: 50),
            buttonCancel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
