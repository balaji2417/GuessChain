//
//  ViewProfileControllerViewController.swift
//  GuessChain
//
//  Created by Balaji Sundar on 11/17/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewProfileController: UIViewController {
    
    
    let viewContact = ViewProfileView()
    
    var profileName: String = ""
    var profileEmail: String = ""
    var profilePhone: String = ""
    var profilePhoneType: String = ""
    var profileStreet: String?
    var profileCity: String = ""
    var profileZip: String = ""
    
    var database: Firestore {
        return Firestore.firestore()
    }
    
    
    override func loadView() {
        self.view = viewContact
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        var editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(onEditButtonTapped)
        )
        
        let logoutButton = UIBarButtonItem(title: "Logout",
                                           style: .plain,
                                           target: self,
                                           action: #selector(onLogoutTapped))
        
        navigationItem.rightBarButtonItems = [editButton, logoutButton]
        
        fetchUserProfile()
        
    }
    
    func fetchUserProfile() {
        guard let currentUser = Auth.auth().currentUser else {
            showAlert(message: "No user logged in")
            return
        }
        
        database.collection("users").document(currentUser.uid).getDocument(source: .default) { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: "Failed to fetch profile: \(error.localizedDescription)")
                return
            }
            
            guard let document = document,
                  document.exists,
                  let data = document.data() else {
                self.showAlert(message: "Profile data not found")
                return
            }
            
            self.profileName = data["name"] as? String ?? ""
            self.profileEmail = data["email"] as? String ?? ""
            self.profilePhone = data["phone"] as? String ?? ""
            self.profilePhoneType = data["phoneType"] as? String ?? "Cell"
            self.profileStreet = data["street"] as? String ?? ""
            self.profileCity = data["city"] as? String ?? ""
            self.profileZip = data["zip"] as? String ?? ""
            
            
            self.configureViewWithDetails()
        }
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
        
        if let street = profileStreet, !street.isEmpty {
            viewContact.streetLabel.text = street
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
        editVC.profileStreet = profileStreet ?? ""
        editVC.profileCity = profileCity
        editVC.profileZip = profileZip
        
        editVC.delegate = self

        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func onLogoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    func performLogout() {
        do {
            try Auth.auth().signOut()
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                let loginVC = ViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        } catch {
            showAlert(message: "Failed to logout: \(error.localizedDescription)")
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension ViewProfileController: EditProfileDelegate {
    func didUpdateProfile(name: String?, email: String?, phone: String?, phoneType: String?, street: String?, city: String?, zip: String?) {
        guard let currentUser = Auth.auth().currentUser else {
            showAlert(message: "No user logged in")
            return
        }
        
        var updateData: [String: Any] = [:]
        
        if let name = name {
            updateData["name"] = name
            profileName = name
        }
        
        if let email = email {
            updateData["email"] = email
            profileEmail = email
        }
        
        if let phone = phone {
            updateData["phone"] = phone
            profilePhone = phone
        }
        
        if let phoneType = phoneType {
            updateData["phoneType"] = phoneType
            profilePhoneType = phoneType
        }
        
        updateData["street"] = street ?? ""
        profileStreet = street ?? ""
        
        if let city = city {
            updateData["city"] = city
            profileCity = city
        }
        
        if let zip = zip {
            updateData["zip"] = zip
            profileZip = zip
        }
        
        database.collection("users").document(currentUser.uid).updateData(updateData) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: "Failed to update profile: \(error.localizedDescription)")
                return
            }
            
            self.configureViewWithDetails()
        }
    }
}

