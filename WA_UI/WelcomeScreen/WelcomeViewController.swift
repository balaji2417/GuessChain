//
//  WelcomeViewController.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    var welcomeView: WelcomeScreenUI!
    
    override func loadView() {
        welcomeView = WelcomeScreenUI()
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        welcomeView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        welcomeView.profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        welcomeView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
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
    
    @objc private func logoutButtonTapped() {
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
    
    private func performLogout() {
        do {
            try Auth.auth().signOut()
            navigationController?.setViewControllers([ViewController()], animated: true)
        } catch let error {
            showAlert(message: "Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
