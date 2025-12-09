//
//  LobbyDisplayManager.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/6/25.
//

//let id: String
//let name: String
//let players: [Player]
//let maxPlayers: Int

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension LobbyViewController {
    func listenToAllLobbies() -> ListenerRegistration {
        let db = Firestore.firestore()
        
        return db.collection("lobby").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.rooms = []
            for document in documents {
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                var players: [Player] = []
                
                if let playersData = data["players"] as? [[String: Any]] {
                    for playerData in playersData {
                        let playerName = playerData["name"] as? String ?? ""
                        let playerId = playerData["id"] as? String ?? ""
                        let playerScore = playerData["score"] as? Int ?? 0
                        
                        // Skip empty players
                        if !playerId.isEmpty && !playerName.isEmpty {
                            let player = Player(name: playerName, id: playerId, score: playerScore)
                            players.append(player)
                        }
                    }
                }
                
                let maxPlayers = 4
                
                // Only show rooms that are waiting or have space
                let gameStatus = data["gameStatus"] as? String ?? "waiting"
                if gameStatus == "waiting" {
                    let lobby = Room(id: id, name: name, players: players, maxPlayers: maxPlayers)
                    self.rooms.append(lobby)
                }
            }
            
            DispatchQueue.main.async {
                self.lobbyView.tableViewRooms.reloadData()
            }
        }
    }
    
    func getUserName() {
        let database = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else {
            print("No User Logged In...")
            return
        }
        database.collection("users").document(currentUser.uid).getDocument(source: .default) { [weak self] document, error in
            guard let self = self else { return }
            
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
    
    func updateRoom(_ roomId: String, _ player: Player) {
        let db = Firestore.firestore()
        
        // Initialize score to 0 when joining
        let playerData: [String: Any] = [
            "name": player.name,
            "id": player.id,
            "score": 0
        ]
        
        // Use transaction to prevent race conditions
        let roomRef = db.collection("lobby").document(roomId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let roomDocument: DocumentSnapshot
            do {
                try roomDocument = transaction.getDocument(roomRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let existingPlayers = roomDocument.data()?["players"] as? [[String: Any]] else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve players"]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            // Count non-empty players
            let validPlayers = existingPlayers.filter {
                !($0["id"] as? String ?? "").isEmpty
            }
            
            // Check if room is full
            if validPlayers.count >= 4 {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Room is full"]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            // Check if player already in room
            for existingPlayer in validPlayers {
                if let existingId = existingPlayer["id"] as? String, existingId == player.id {
                    // Player already in room, don't add again
                    return nil
                }
            }
            
            // Add player to room
            transaction.updateData([
                "players": FieldValue.arrayUnion([playerData]),
                "gameStatus": "waiting"
            ], forDocument: roomRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Error joining room: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(message: "Could not join room: \(error.localizedDescription)")
                }
            } else {
                print("\(player.name) joined the room")
            }
        }
    }
}
