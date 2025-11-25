//
//  ViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var welcomeView: WelcomeScreenUI!
    
    override func loadView() {
        welcomeView = WelcomeScreenUI()
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        welcomeView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        welcomeView.profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func playButtonTapped() {
        print("Play button tapped!")
        let lobbyVC = LobbyViewController()
        navigationController?.pushViewController(lobbyVC, animated: true)
    }
    
    @objc private func profileButtonTapped() {
        print("Profile button tapped!")
        let profileVC = ViewProfileController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}

