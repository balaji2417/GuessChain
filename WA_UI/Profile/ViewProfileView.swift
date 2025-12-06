//
//  ViewProfileView.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

class ViewProfileView: UIView {

        var nameLabel: UILabel!
        var emailLabel: UILabel!
        var phoneLabel: UILabel!
        var addressTagLabel: UILabel!
        var streetLabel: UILabel!
        var cityLabel: UILabel!
        var zipLabel: UILabel!
        var imageView: UIImageView!
        
        var mainStackView: UIStackView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .systemBackground
            setupViews()
            setupLayout()
        }
        
        func setupViews() {
            imageView = UIImageView()
            imageView.image = UIImage(systemName: "photo")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 50
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(imageView)
            
        
            nameLabel = UILabel()
            nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
            nameLabel.textAlignment = .center
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(nameLabel)
            
            mainStackView = UIStackView()
            mainStackView.axis = .vertical
            mainStackView.alignment = .center
            mainStackView.spacing = 8
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(mainStackView)
            
            emailLabel = UILabel()
            emailLabel.font = .systemFont(ofSize: 16)
            mainStackView.addArrangedSubview(emailLabel)
            
            phoneLabel = UILabel()
            phoneLabel.font = .systemFont(ofSize: 16)
            mainStackView.addArrangedSubview(phoneLabel)
            
            mainStackView.setCustomSpacing(24, after: phoneLabel)
            
            addressTagLabel = UILabel()
            addressTagLabel.text = "Address:"
            addressTagLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            mainStackView.addArrangedSubview(addressTagLabel)
            
            streetLabel = UILabel()
            streetLabel.font = .systemFont(ofSize: 16)
            streetLabel.numberOfLines = 0
            mainStackView.addArrangedSubview(streetLabel)
            
            cityLabel = UILabel()
            cityLabel.font = .systemFont(ofSize: 16)
            cityLabel.numberOfLines = 0
            mainStackView.addArrangedSubview(cityLabel)
            
            zipLabel = UILabel()
            zipLabel.font = .systemFont(ofSize: 16)
            zipLabel.numberOfLines = 0
            mainStackView.addArrangedSubview(zipLabel)
        }
        
        func setupLayout() {
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                
                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
                nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                
                mainStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
