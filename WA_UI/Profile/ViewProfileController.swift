//
//  ViewProfileControllerViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit

class ViewProfileController: UIViewController {
    
    let viewContact = ViewProfileView()
    
    var profileName: String = ""
    var profileEmail: String = ""
    var profilePhone: String = ""
    var profilePhoneType: String = ""
    var profileStreet: String = ""
    var profileCity: String = ""
    var profileZip: String = ""
    
    override func loadView() {
        self.view = viewContact
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.observe(from: self)
        title = "Profile"
        
        let editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(onEditButtonTapped)
        )
        
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(onLogoutTapped)
        )
        
        navigationItem.rightBarButtonItems = [editButton, logoutButton]
        
        fetchUserProfile()
    }
    
    func configureViewWithDetails() {
        viewContact.nameLabel.text = profileName.isEmpty ? "Add your name" : profileName
        viewContact.emailLabel.text = profileEmail.isEmpty ? "Add your email" : profileEmail
        
        if !profilePhone.isEmpty {
            viewContact.phoneLabel.text = profilePhone
        } else {
            viewContact.phoneLabel.text = "Add phone number"
            viewContact.phoneLabel.textColor = .systemGray
        }
        
        if !profileStreet.isEmpty {
            viewContact.streetLabel.text = profileStreet
            viewContact.streetLabel.isHidden = false
        } else {
            viewContact.streetLabel.isHidden = true
        }
        
        if !profileCity.isEmpty {
            viewContact.cityLabel.text = profileCity
            viewContact.cityLabel.textColor = .label
        } else {
            viewContact.cityLabel.text = "Add city"
            viewContact.cityLabel.textColor = .systemGray
        }
        
        if !profileZip.isEmpty {
            viewContact.zipLabel.text = profileZip
            viewContact.zipLabel.textColor = .label
        } else {
            viewContact.zipLabel.text = "Add ZIP code"
            viewContact.zipLabel.textColor = .systemGray
        }
        
        if viewContact.imageView.image == nil {
            viewContact.imageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    @objc func onEditButtonTapped() {
        let editVC = EditProfileViewController()
        
        editVC.profileName = profileName
        editVC.profileEmail = profileEmail
        editVC.profilePhone = profilePhone
        editVC.profilePhoneType = profilePhoneType
        editVC.profileStreet = profileStreet
        editVC.profileCity = profileCity
        editVC.profileZip = profileZip
        
        editVC.delegate = self
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func onLogoutTapped() {
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension ViewProfileController: EditProfileDelegate {
    func didUpdateProfile(name: String?, email: String?, phone: String?, phoneType: String?, street: String?, city: String?, zip: String?) {
        updateUserProfile(name: name, email: email, phone: phone, phoneType: phoneType, street: street, city: city, zip: zip)
    }
}
