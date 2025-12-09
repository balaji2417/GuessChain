//
//  LeaderboardViewController.swift
//  WA_UI
//
//  Created by Swetha Shankara Raman on 11/17/25.
//

import UIKit

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
        
        title = "Results"
        navigationItem.hidesBackButton = true
        
        leaderboardView.backButton.addTarget(self, action: #selector(onBackToLobby), for: .touchUpInside)
        
        setupLeaderboard()
    }
    
    func setupLeaderboard() {
        sortedPlayers = players
            .filter { !$0.id.hasPrefix("bot_") }
            .sorted { $0.score > $1.score }
        
        if sortedPlayers.isEmpty {
            sortedPlayers = players.sorted { $0.score > $1.score }
        }
        
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
        
        leaderboardView.clearPlayerCards()
        for (index, player) in sortedPlayers.enumerated() {
            let rank = index + 1
            let displayName = player.id == myPlayerId ? "YOU" : player.name
            leaderboardView.addPlayerCard(rank: rank, name: displayName, score: player.score)
        }
    }
    
    @objc func onBackToLobby() {
        // Delete the room from Firestore
        GameManager.shared.deleteRoom(roomId: roomId) { [weak self] success, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error deleting room: \(error)")
                }
                
                self?.navigationController?.setViewControllers([LobbyViewController()], animated: true)
            }
        }
    }
}
