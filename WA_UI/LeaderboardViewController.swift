//
//  LeaderboardViewController.swift
//  WA_UI
//
//  Created by Sudharshan Ramesh on 11/17/25.
//

import UIKit

struct PlayerScore {
    let rank: Int
    let name: String
    let score: Int
}

class LeaderboardViewController: UIViewController {
    
    var leaderboardView: LeaderboardView!
    
    var otherPlayers: [PlayerScore] = [
        PlayerScore(rank: 4, name: "player4", score: 40),
        PlayerScore(rank: 5, name: "player5", score: 30),
        PlayerScore(rank: 6, name: "player6", score: 20)
    ]
    
    override func loadView() {
        leaderboardView = LeaderboardView()
        view = leaderboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardView.playersTable.delegate = self
        leaderboardView.playersTable.dataSource = self
        
        leaderboardView.playAgainButton.addTarget(self, action: #selector(onPlayAgain), for: .touchUpInside)
        leaderboardView.backButton.addTarget(self, action: #selector(onBackToLobby), for: .touchUpInside)
    }
    
    @objc func onPlayAgain() {
        print("play again clicked")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onBackToLobby() {
        navigationController?.setViewControllers([LobbyViewController()], animated: true)
    }
}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        let player = otherPlayers[indexPath.row]
        cell.configure(rank: player.rank, name: player.name, score: player.score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
