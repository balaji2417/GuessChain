//
//  CreateRoomViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit
import FirebaseAuth

class CreateRoomViewController: UIViewController {
    
    var createRoomView: CreateRoomView!
    var player: Player = Player(name: "", id: "")
    override func loadView() {
        createRoomView = CreateRoomView()
        view = createRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.observe(from: self)
        if Auth.auth().currentUser != nil {
            getUserName ()
        }
        createRoomView.buttonCreate.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createRoomView.buttonCancel.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func createButtonTapped() {
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        guard let roomName = createRoomView.textFieldRoomName.text, !roomName.isEmpty else {
            showAlert(message: "Please enter a room name")
            return
        }
        
        print("Room created: \(roomName)")
        createRoom(roomName)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
