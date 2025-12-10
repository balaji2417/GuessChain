//
//  CreateRoomManager.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension CreateRoomViewController {
    
    func createRoom(_ roomName: String) {
        let db = Firestore.firestore()
        let roomData: [String: Any] = [
            "name": roomName,
            "players": [],
            "maxPlayers": 4,
            "gameStatus": "waiting",
            "createdBy": self.player.id ?? "",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("lobby").addDocument(data: roomData) { error in
            if let error = error {
                print("Error creating room: \(error)")
                return
            }
            print("Room created: \(roomName)")
        }
    }
    
    func getUserName() {
        let database = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else {
            print("No User Logged In...")
            
            return
        }
        
        database.collection("users").document(currentUser.uid).getDocument(source: .default) { [weak self] document, error in
            guard let self = self else {
                
                return
            }
            
            if let error = error {
                print("Failed to get user data: \(error)")
                
                return
            }
            
            guard let document = document,
                  document.exists,
                  let data = document.data() else {
                print("Not Found Data")
                
                return
            }
            
            self.player.name = data["name"] as? String ?? ""
            self.player.id = document.documentID
            
        }
    }
}
