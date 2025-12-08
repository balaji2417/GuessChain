//
//  ViewProfileView.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

class ViewProfileView: UIView {
    var nameLabel: UILabel!
    var emailTitleLabel: UILabel!
    var emailLabel: UILabel!
    var phoneTitleLabel: UILabel!
    var phoneLabel: UILabel!
    var addressTagLabel: UILabel!
    var streetTitleLabel: UILabel!
    var streetLabel: UILabel!
    var cityTitleLabel: UILabel!
    var cityLabel: UILabel!
    var zipTitleLabel: UILabel!
    var zipLabel: UILabel!
    var imageView: UIImageView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var contactCard: UIView!
    var addressCard: UIView!
    var contactStack: UIStackView!
    var addressStack: UIStackView!
    var addressIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
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
        
        contactStack = UIStackView()
        contactStack.axis = .vertical
        contactStack.spacing = 16
        contactStack.translatesAutoresizingMaskIntoConstraints = false
        contactCard.addSubview(contactStack)
        
        let emailStackView = createFieldStackView(icon: "envelope.fill")
        contactStack.addArrangedSubview(emailStackView)
        
        emailTitleLabel = UILabel()
        emailTitleLabel.text = "Email"
        emailTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        emailTitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        emailStackView.addArrangedSubview(emailTitleLabel)
        
        emailLabel = UILabel()
        emailLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        emailLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        emailStackView.addArrangedSubview(emailLabel)
        
        let divider1 = createDivider()
        contactStack.addArrangedSubview(divider1)
        
        let phoneStackView = createFieldStackView(icon: "phone.fill")
        contactStack.addArrangedSubview(phoneStackView)
        
        phoneTitleLabel = UILabel()
        phoneTitleLabel.text = "Phone"
        phoneTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        phoneTitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        phoneStackView.addArrangedSubview(phoneTitleLabel)
        
        phoneLabel = UILabel()
        phoneLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        phoneLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        phoneStackView.addArrangedSubview(phoneLabel)
        
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
        
        addressStack = UIStackView()
        addressStack.axis = .vertical
        addressStack.spacing = 16
        addressStack.translatesAutoresizingMaskIntoConstraints = false
        addressCard.addSubview(addressStack)
        
        let addressHeaderStack = UIStackView()
        addressHeaderStack.axis = .horizontal
        addressHeaderStack.spacing = 8
        addressHeaderStack.alignment = .center
        
        addressIcon = UIImageView()
        addressIcon.image = UIImage(systemName: "location.fill")
        addressIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        addressIcon.contentMode = .scaleAspectFit
        addressIcon.translatesAutoresizingMaskIntoConstraints = false
        addressHeaderStack.addArrangedSubview(addressIcon)
        
        addressTagLabel = UILabel()
        addressTagLabel.text = "Address"
        addressTagLabel.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        addressTagLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        addressHeaderStack.addArrangedSubview(addressTagLabel)
        addressStack.addArrangedSubview(addressHeaderStack)
        
        let divider2 = createDivider()
        addressStack.addArrangedSubview(divider2)
        
        let streetStackView = createAddressFieldStackView()
        addressStack.addArrangedSubview(streetStackView)
        
        streetTitleLabel = UILabel()
        streetTitleLabel.text = "Street"
        streetTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        streetTitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        streetStackView.addArrangedSubview(streetTitleLabel)
        
        streetLabel = UILabel()
        streetLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        streetLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        streetLabel.numberOfLines = 0
        streetStackView.addArrangedSubview(streetLabel)
        
        let cityStackView = createAddressFieldStackView()
        addressStack.addArrangedSubview(cityStackView)
        
        cityTitleLabel = UILabel()
        cityTitleLabel.text = "City"
        cityTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        cityTitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        cityStackView.addArrangedSubview(cityTitleLabel)
        
        cityLabel = UILabel()
        cityLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        cityLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        cityLabel.numberOfLines = 0
        cityStackView.addArrangedSubview(cityLabel)
        
        let zipStackView = createAddressFieldStackView()
        addressStack.addArrangedSubview(zipStackView)
        
        zipTitleLabel = UILabel()
        zipTitleLabel.text = "ZIP"
        zipTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        zipTitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        zipStackView.addArrangedSubview(zipTitleLabel)
        
        zipLabel = UILabel()
        zipLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        zipLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        zipLabel.numberOfLines = 0
        zipStackView.addArrangedSubview(zipLabel)
    }
    
    func createFieldStackView(icon: String) -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .top
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        container.addArrangedSubview(iconView)
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4
        container.addArrangedSubview(textStack)
        
        return textStack
    }
    
    func createAddressFieldStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactCard.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
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
