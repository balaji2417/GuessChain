//
//  ViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class ViewController: UIViewController {
    
    var welcomeView: WelcomeScreenUI!
    
    override func loadView() {
        welcomeView = WelcomeScreenUI()
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        welcomeView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func playButtonTapped() {
        print("Play button tapped!")
        let lobbyVC = LobbyViewController()
        navigationController?.pushViewController(lobbyVC, animated: true)
    }
    
    
}

