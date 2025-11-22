//
//  ViewProfileView.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

class ViewProfileView: UIView {

      
        
        // Keep references to all your UI elements
        var nameLabel: UILabel!
        var emailLabel: UILabel!
        var phoneLabel: UILabel!
        var addressTagLabel: UILabel!
        var streetLabel: UILabel!
        var cityLabel: UILabel!
        var zipLabel: UILabel!
        var imageView: UIImageView!
        
        // Use a Stack View to manage the detail labels
        var mainStackView: UIStackView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // Use .systemBackground for light/dark mode compatibility
            backgroundColor = .systemBackground
            
            // Break setup into two steps: creating views and setting layout
            setupViews()
            setupLayout()
        }
        
        func setupViews() {
            // --- Image View ---
            imageView = UIImageView()
            imageView.image = UIImage(systemName: "photo") // Placeholder image
            imageView.contentMode = .scaleAspectFill // Fills the circle without stretching
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 50 // Makes it a circle (half of 100)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(imageView)
            
            // --- Name Label ---
            nameLabel = UILabel()
            nameLabel.font = .systemFont(ofSize: 24, weight: .bold) // Larger, bolder font for name
            nameLabel.textAlignment = .center
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(nameLabel)
            
            // --- Main Stack View ---
            // This will hold all the detail labels vertically
            mainStackView = UIStackView()
            mainStackView.axis = .vertical
            // --- THIS IS THE CHANGE ---
            mainStackView.alignment = .center // Center-align all content
            // --- END OF CHANGE ---
            mainStackView.spacing = 8 // Standard spacing between items
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(mainStackView)
            
            // --- Create and Add Labels to the Stack View ---
            
            emailLabel = UILabel()
            emailLabel.font = .systemFont(ofSize: 16)
            mainStackView.addArrangedSubview(emailLabel) // Add to stack view
            
            phoneLabel = UILabel()
            phoneLabel.font = .systemFont(ofSize: 16)
            mainStackView.addArrangedSubview(phoneLabel)
            
            // Add extra space before the "Address" section
            mainStackView.setCustomSpacing(24, after: phoneLabel)
            
            addressTagLabel = UILabel()
            addressTagLabel.text = "Address:"
            addressTagLabel.font = .systemFont(ofSize: 20, weight: .semibold) // Section header style
            mainStackView.addArrangedSubview(addressTagLabel)
            
            streetLabel = UILabel()
            streetLabel.font = .systemFont(ofSize: 16)
            streetLabel.numberOfLines = 0 // Allow multi-line
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
            // Define standard padding
            let padding: CGFloat = 20.0
            
            NSLayoutConstraint.activate([
                // Image View: Top-Center
                imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                
                // Name Label: Below image, centered
                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
                nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
                nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
                
                // Main Stack View: Below name, pinned to sides
                // The stack view itself still spans the width,
                // but its *content* is now centered.
                mainStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
                
                // Note: We don't need to constrain the labels inside mainStackView.
                // The stack view does that for us!
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
