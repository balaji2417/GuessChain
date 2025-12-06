//
//  LobbyViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth



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
    var player : Player = Player(name: "", id: "")
    
    // Data will be fetched from backend.
    var rooms: [Room] = []

    var listener: ListenerRegistration?
   
    override func loadView() {
        lobbyView = LobbyView()
        view = lobbyView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getUserName()
        listener = listenToAllLobbies()
        // Do any additional setup after loading the view.
        lobbyView.tableViewRooms.delegate = self
        lobbyView.tableViewRooms.dataSource = self
        
        lobbyView.buttonCreateRoom.addTarget(self, action: #selector(createRoomTapped), for: .touchUpInside)
        lobbyView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc func createRoomTapped() {
        let createRoomVC = CreateRoomViewController()
        navigationController?.pushViewController(createRoomVC, animated: true)
    }
    
    @objc func joinRoomTapped(_ sender: UIButton) {
        let roomIndex = sender.tag
        let room = rooms[roomIndex]
        
        print("Player :",player.name)
        updateRoom(room.id,player)
        
        let gameVC = GameScreenViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func logoutTapped() {
        navigationController?.setViewControllers([ViewController()], animated: true)
    }
    
}


extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        let room = rooms[indexPath.row]
        let players = room.maxPlayers - room.players.count
        if (players == 0) {
            cell.buttonJoin.isEnabled = false
        }
        cell.configure(with: room)
        
        cell.buttonJoin.tag = indexPath.row
        cell.buttonJoin.addTarget(self, action: #selector(joinRoomTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
