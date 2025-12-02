//
//  LoginApi.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/2/25.
//

import Foundation
import UIKit
import FirebaseAuth

extension ViewController {
    func loginApi(_ email : String, _ password : String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                self.navigateToHome()
                
            }
            else{
                if let uwError = error {
                    print(uwError)
                    self.showError()
                }
               
            }
        })
    }
}
