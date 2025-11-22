//
//  GameScreenViewController.swift
//  WA_UI
//
//  Created by Sudharshan Ramesh on 11/17/25.
//


import UIKit

class GameScreenViewController: UIViewController {
    
    var gameView: GameScreenView!
    var currentScore: Int = 0
    var endGameBtn: UIButton!
    
    override func loadView() {
        gameView = GameScreenView()
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        gameView.goBtn.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        
        // sample chain
        gameView.addLink(txt: "Spider-Man", playerName: "alex")
        gameView.addLink(txt: "Tom Holland", playerName: "sam")
        gameView.addLink(txt: "Uncharted", playerName: "mike")
        
        // add end game button for testing
        setupEndGameBtn()
    }
    
    func setupEndGameBtn() {
        endGameBtn = UIButton(type: .system)
        endGameBtn.setTitle("end game", for: .normal)
        endGameBtn.titleLabel?.font = UIFont(name: "Menlo", size: 14) ?? .monospacedSystemFont(ofSize: 14, weight: .regular)
        endGameBtn.setTitleColor(.white, for: .normal)
        endGameBtn.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        endGameBtn.layer.cornerRadius = 15
        endGameBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endGameBtn)
        
        NSLayoutConstraint.activate([
            endGameBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            endGameBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            endGameBtn.widthAnchor.constraint(equalToConstant: 100),
            endGameBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        endGameBtn.addTarget(self, action: #selector(goToLeaderboard), for: .touchUpInside)
    }
    
    @objc func submitAnswer() {
        guard let ans = gameView.answerField.text, !ans.isEmpty else {
            let alert = UIAlertController(title: "oops", message: "type something first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        gameView.addLink(txt: ans, playerName: "you")
        gameView.answerField.text = ""
        
        currentScore += 10
        gameView.scoreTxt.text = "\(currentScore)"
    }
    
    @objc func goToLeaderboard() {
        print("going to leaderboard")
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }

}
