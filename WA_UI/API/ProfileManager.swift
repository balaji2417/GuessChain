//
//  ProfileManager.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 12/7/25.
//



import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

struct UserProfile {
    var name: String
    var email: String
    var phone: String
    var phoneType: String
    var street: String
    var city: String
    var zip: String
}


extension ViewProfileController {
    private var database: Firestore {
        return Firestore.firestore()
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
    
    func updateUserProfile(name: String?, email: String?, phone: String?, phoneType: String?, street: String?, city: String?, zip: String?) {
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
}
