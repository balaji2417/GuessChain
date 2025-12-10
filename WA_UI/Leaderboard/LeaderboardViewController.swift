//
//  LeaderboardViewController.swift
//  WA_UI
//
//  Created by Swetha Shankara Rama on 11/17/25.
//


import UIKit
import FirebaseFirestore

class LeaderboardViewController: UIViewController {
    
    var leaderboardView: LeaderboardView!
    var roomId: String = ""
    var myPlayerId: String = ""
    var players: [Player] = []
    
    var sortedPlayers: [Player] = []
    
    override func loadView() {
        leaderboardView = LeaderboardView()
        view = leaderboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.observe(from: self)
        title = "Results"
        navigationItem.hidesBackButton = true
        
        leaderboardView.backButton.addTarget(self, action: #selector(onBackToLobby), for: .touchUpInside)
        
        setupLeaderboard()
    }
    
    func setupLeaderboard() {
        // Filter out bots and sort by score
        sortedPlayers = players
            .filter { !$0.id.hasPrefix("bot_") }
            .sorted { $0.score > $1.score }
        
        // If we have all bots, show them too
        if sortedPlayers.isEmpty {
            sortedPlayers = players.sorted { $0.score > $1.score }
        }
        
        // Update podium (top 3)
        if sortedPlayers.count >= 1 {
            let displayName = sortedPlayers[0].id == myPlayerId ? "YOU" : sortedPlayers[0].name
            leaderboardView.firstNameLabel.text = displayName
            leaderboardView.firstScoreLabel.text = "\(sortedPlayers[0].score)"
        }
        
        if sortedPlayers.count >= 2 {
            let displayName = sortedPlayers[1].id == myPlayerId ? "YOU" : sortedPlayers[1].name
            leaderboardView.secondNameLabel.text = displayName
            leaderboardView.secondScoreLabel.text = "\(sortedPlayers[1].score)"
        } else {
            leaderboardView.secondPlaceCard.isHidden = true
        }
        
        if sortedPlayers.count >= 3 {
            let displayName = sortedPlayers[2].id == myPlayerId ? "YOU" : sortedPlayers[2].name
            leaderboardView.thirdNameLabel.text = displayName
            leaderboardView.thirdScoreLabel.text = "\(sortedPlayers[2].score)"
        } else {
            leaderboardView.thirdPlaceCard.isHidden = true
        }
        
        // Add ALL players as cards below medals
        leaderboardView.clearPlayerCards()
        for (index, player) in sortedPlayers.enumerated() {
            let rank = index + 1
            let displayName = player.id == myPlayerId ? "YOU" : player.name
            leaderboardView.addPlayerCard(rank: rank, name: displayName, score: player.score)
        }
    }
    
    @objc func onBackToLobby() {
        let db = Firestore.firestore()
        let roomRef = db.collection("lobby").document(roomId)
        
        // Get current room data
        roomRef.getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  var players = data["players"] as? [[String: Any]] else {
                // If room doesn't exist or error, just go back
                DispatchQueue.main.async {
                    self?.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                }
                return
            }
            
            // Remove current player from room
            players.removeAll { $0["id"] as? String == self.myPlayerId }
            
            if players.isEmpty {
                // Last player leaving - delete the room
                GameManager.shared.deleteRoom(roomId: self.roomId) { _, _ in
                    DispatchQueue.main.async {
                        self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                    }
                }
            } else {
                // Other players still viewing leaderboard - just remove yourself
                roomRef.updateData(["players": players]) { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                    }
                }
            }
        }
    }
}
