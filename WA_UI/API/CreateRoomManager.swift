//
//  CreateRoomManager.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/6/25.
//

//
//  CreateRoomManager.swift
//  GuessChain
//
//  Ensures createdBy field is set when creating room
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension CreateRoomViewController {
    
    func createRoom(_ roomName: String) {
        let db = Firestore.firestore()
        
        guard !player.id.isEmpty else {
            showAlert(message: "Please wait, loading your profile...")
            return
        }
        
        // Check if room name already exists
        db.collection("lobby").whereField("name", isEqualTo: roomName).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error checking room name: \(error)")
                self.showAlert(message: "Error creating room")
                return
            }
            
            // Check if any rooms with this name exist
            if let documents = snapshot?.documents, !documents.isEmpty {
                self.showAlert(message: "Room name already exists. Please choose a different name.")
                return
            }
            
            // Room name is unique - create it
            let roomData: [String: Any] = [
                "name": roomName,
                "players": [],
                "maxPlayers": 4,
                "gameStatus": "waiting",
                "createdBy": self.player.id,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            db.collection("lobby").addDocument(data: roomData) { error in
                if let error = error {
                    print("Error creating room: \(error)")
                    self.showAlert(message: "Error creating room")
                    return
                }
                print("Room created: \(roomName) by \(self.player.name)")
            }
        }
    }
    
    func getUserName() {
        let database = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else {
            print("No User Logged In...")
            return
        }
        
        database.collection("users").document(currentUser.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to get user data: \(error)")
                return
            }
            
            guard let document = document,
                  document.exists,
                  let data = document.data() else {
                print("User data not found")
                return
            }
            
            self.player.name = data["name"] as? String ?? ""
            self.player.id = document.documentID
        }
    }
}
