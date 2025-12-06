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
                                   let player = Player(name: playerName, id: playerId)
                                   players.append(player)
                               }
                           }
                       let maxPlayers = 4
                       let lobby = Room(id: id, name: name, players: players, maxPlayers: maxPlayers)
                       self.rooms.append(lobby)
                       
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
                print("Falsed to get user data: \(error)")
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
        
        let playerData: [String: Any] = [
            "name": player.name,
            "id": player.id
        ]
        
        db.collection("lobby").document(roomId).updateData([
            "players": FieldValue.arrayUnion([playerData])
        ]) { error in
            if let error = error {
                print("Error joining room: \(error)")
                return
            }
            print("\(player.name) joined the room")
        }
    }
}
