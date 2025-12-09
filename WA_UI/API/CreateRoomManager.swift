//
//  CreateRoomManager.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/6/25.
//

import Foundation
import FirebaseFirestore

extension CreateRoomViewController {
    
    func createRoom(_ roomName: String) {
        let db = Firestore.firestore()
        let roomData: [String: Any] = [
            "name": roomName,
            "players": [],
            "maxPlayers": 4,
            "gameStatus": "waiting",
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
}
