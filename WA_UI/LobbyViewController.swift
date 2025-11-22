//
//  LobbyViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

struct Player {
    let name: String
    let avatar: String
}

struct Room {
    let id: String
    let name: String
    let players: [Player]
    let maxPlayers: Int
}

class LobbyViewController: UIViewController {
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    var lobbyView: LobbyView!
    
    // Dummy data
    var rooms: [Room] = [
        Room(id: "1", name: "Room Alpha", players: [
            Player(name: "Player1", avatar: "🎮"),
            Player(name: "Player2", avatar: "🎯")
        ], maxPlayers: 4),
        Room(id: "2", name: "Room Beta", players: [
            Player(name: "Player3", avatar: "🎲")
        ], maxPlayers: 4),
        Room(id: "3", name: "Room Gamma", players: [
            Player(name: "Player4", avatar: "🎪"),
            Player(name: "Player5", avatar: "🎭"),
            Player(name: "Player6", avatar: "🎨")
        ], maxPlayers: 4)
    ]
    
    override func loadView() {
        lobbyView = LobbyView()
        view = lobbyView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lobbyView.tableViewRooms.delegate = self
        lobbyView.tableViewRooms.dataSource = self
        
        lobbyView.buttonCreateRoom.addTarget(self, action: #selector(createRoomTapped), for: .touchUpInside)
    }
    
    
    
    
    @objc func createRoomTapped() {
        print("Create room tapped")
        let createRoomVC = CreateRoomViewController()
        navigationController?.pushViewController(createRoomVC, animated: true)
    }
    
    @objc func joinRoomTapped(_ sender: UIButton) {
        let roomIndex = sender.tag
        let room = rooms[roomIndex]
        print("Join room tapped: \(room.name)")
        
        // Navigate to game screen
        let gameVC = GameScreenViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
}


extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        let room = rooms[indexPath.row]
        cell.configure(with: room)
        cell.buttonJoin.tag = indexPath.row
        cell.buttonJoin.addTarget(self, action: #selector(joinRoomTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
