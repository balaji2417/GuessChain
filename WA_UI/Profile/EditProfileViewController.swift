//
//  EditProfileViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 12/5/25.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(name: String?, email: String?, phone: String?, phoneType: String?, street: String?, city: String?, zip: String?)
}

class EditProfileViewController: UIViewController {
    
    var delegate: EditProfileDelegate?
    
    var profileName: String = ""
    var profileEmail: String = ""
    var profilePhone: String = ""
    var profilePhoneType: String = "Cell"
    var profileStreet: String = ""
    var profileCity: String = ""
    var profileZip: String = ""
    
    let editProfileView = EditProfileView()
    
    let phoneTypes = ["Cell", "Work", "Home"]
    var selectedPhoneType = "Cell"
    
    override func loadView() {
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(onSaveButtonTapped)
        )
        
        
        editProfileView.buttonPhoneType.addTarget(self, action: #selector(onPhoneTypeButtonTapped), for: .touchUpInside)
        
        populateFields()
    }
    
    
    func populateFields() {
        editProfileView.nameField.text = profileName
        editProfileView.emailField.text = profileEmail
        if !profilePhone.isEmpty {
            editProfileView.phoneField.text = profilePhone
        }
        
        if !profilePhoneType.isEmpty {
            selectedPhoneType = profilePhoneType
            editProfileView.buttonPhoneType.setTitle(profilePhoneType, for: .normal)
        }
        
        if !profileStreet.isEmpty {
            editProfileView.streetField.text = profileStreet
        }
        
        if !profileCity.isEmpty {
            editProfileView.cityField.text = profileCity
        }
        
        if !profileZip.isEmpty {
            editProfileView.zipField.text = profileZip
        }
        
    }
    
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc func onPhoneTypeButtonTapped() {
        let alert = UIAlertController(title: "Select Phone Type", message: nil, preferredStyle: .actionSheet)
        
        for phoneType in phoneTypes {
            alert.addAction(UIAlertAction(title: phoneType, style: .default) { [weak self] _ in
                self?.selectedPhoneType = phoneType
                self?.editProfileView.buttonPhoneType.setTitle(phoneType, for: .normal)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
        present(alert, animated: true)
    }
    
    @objc func onSaveButtonTapped() {
        guard let nameText = editProfileView.nameField.text, !nameText.isEmpty else {
            showAlert(message: "Name cannot be empty")
            return
        }
        
        guard let emailText = editProfileView.emailField.text, !emailText.isEmpty else {
            showAlert(message: "Email cannot be empty")
            return
        }
        
        guard isValidEmail(emailText) else {
            showAlert(message: "Please enter a valid email")
            return
        }
        
        // Validate Phone
        var phoneText: String? = nil
        if let phone = editProfileView.phoneField.text, !phone.isEmpty {
            guard isValidPhone(phone) else {
                showAlert(message: "Phone number must be exactly 10 digits")
                return
            }
            phoneText = phone
        }
        
        let streetText = editProfileView.streetField.text?.isEmpty == false ? editProfileView.streetField.text : nil
        
        var cityText: String? = nil
        if let city = editProfileView.cityField.text, !city.isEmpty {
            cityText = city
        }
        
        var zipText: String? = nil
        if let zip = editProfileView.zipField.text, !zip.isEmpty {
            guard isValidZip(zip) else {
                showAlert(message: "ZIP code must be exactly 5 digits")
                return
            }
            zipText = zip
        }
        

        delegate?.didUpdateProfile(
            name: nameText,
            email: emailText,
            phone: phoneText,
            phoneType: selectedPhoneType,
            street: streetText,
            city: cityText,
            zip: zipText
        )
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Validation Methods
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidZip(_ zip: String) -> Bool {
        let zipRegex = "^[0-9]{5}$"
        let zipPredicate = NSPredicate(format: "SELF MATCHES %@", zipRegex)
        return zipPredicate.evaluate(with: zip)
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phoneTypes.count
    }
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return phoneTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPhoneType = phoneTypes[row]
    }
}
