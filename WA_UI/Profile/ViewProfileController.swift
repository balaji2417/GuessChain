//
//  ViewProfileControllerViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

class ViewProfileController: UIViewController {



        // Create an instance of your custom view
        let viewContact = ViewProfileView()
    
    override func loadView() {
        self.view = viewContact
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Add the custom view to the controller's view
            setupView()
            
            // Populate the view with the contact's details
            configureViewWithDetails()
        }
        
        func setupView() {
          
        }
        
        func configureViewWithDetails() {
            // Set the labels with the provided information
            viewContact.nameLabel.text = "Balaji"
            viewContact.emailLabel.text = "balaji@gmail.com"
            viewContact.phoneLabel.text = "987-654-3210" // Added formatting for readability
            
            // Since street wasn't specified, we can hide the label or leave it empty.
            // Hiding is cleaner if the info isn't there.
            viewContact.streetLabel.isHidden = true
            
            viewContact.cityLabel.text = "Boston"
            viewContact.zipLabel.text = "02119"
            
            // Set the default avatar image
            // 'person.circle.fill' is a great system default
            if let avatarImage = UIImage(systemName: "person.circle.fill") {
                viewContact.imageView.image = avatarImage
                
            }
        }
    }


