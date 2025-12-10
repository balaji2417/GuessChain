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
    
    var lobbyView: LobbyView!
    var player: Player = Player(name: "", id: "")
    
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
        
        lobbyView.tableViewRooms.delegate = self
        lobbyView.tableViewRooms.dataSource = self
        
        lobbyView.buttonCreateRoom.addTarget(self, action: #selector(createRoomTapped), for: .touchUpInside)
        lobbyView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        lobbyView.homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't remove listener, we want to keep getting updates
    }
    
    @objc func createRoomTapped() {
        let createRoomVC = CreateRoomViewController()
        navigationController?.pushViewController(createRoomVC, animated: true)
    }
    
    @objc func homeTapped() {
        navigationController?.pushViewController(WelcomeViewController(), animated: true)
    }
    
    @objc func joinRoomTapped(_ sender: UIButton) {
        let roomIndex = sender.tag
        let room = rooms[roomIndex]
        
        print("Player:", player.name)
        
        // Check if room is full
        if room.players.count >= 4 {
            showAlert(message: "Room is full!")
            return
        }
        
        // Check if player data is valid
        if player.id.isEmpty || player.name.isEmpty {
            showAlert(message: "Please wait, loading your profile...")
            return
        }
        
        updateRoom(room.id, player)
        
        // Navigate to game screen with roomId and playerId
        let gameVC = GameScreenViewController()
        gameVC.roomId = room.id
        gameVC.myPlayerId = player.id
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    func performLogout() {
        do {
            try Auth.auth().signOut()
            navigationController?.setViewControllers([ViewController()], animated: true)
        } catch let error {
            showAlert(message: "Error signing out: \(error.localizedDescription)")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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


