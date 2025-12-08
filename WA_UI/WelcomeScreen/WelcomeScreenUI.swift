//
//  WelcomeScreenUI.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class WelcomeScreenUI: UIView {
    
    var logoContainer: UIView!
    var logoLabel: UILabel!
    var logoIcon: UIImageView!
    var playButton: UIButton!
    var profileButton: UIButton!
    var logoutButton: UIButton!
    var mainCard: UIView!
    var welcomeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupViews()
        initConstraints()
    }
    
    func setupViews() {
        // Logout Button (top right)
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        logoutButton.setTitleColor(UIColor(red: 0.8, green: 0.4, blue: 0.4, alpha: 1.0), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        let logoutIcon = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        logoutButton.setImage(logoutIcon, for: .normal)
        logoutButton.tintColor = UIColor(red: 0.8, green: 0.4, blue: 0.4, alpha: 1.0)
        logoutButton.semanticContentAttribute = .forceLeftToRight
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        self.addSubview(logoutButton)
        
        // Profile Button (top left)
        profileButton = UIButton(type: .system)
        profileButton.setTitle("Profile", for: .normal)
        profileButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        profileButton.setTitleColor(UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0), for: .normal)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        let profileIcon = UIImage(systemName: "person.circle.fill")
        profileButton.setImage(profileIcon, for: .normal)
        profileButton.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        profileButton.semanticContentAttribute = .forceLeftToRight
        profileButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        self.addSubview(profileButton)
        
        // Main Card
        mainCard = UIView()
        mainCard.backgroundColor = .white
        mainCard.layer.cornerRadius = 24
        mainCard.layer.borderWidth = 2
        mainCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        mainCard.layer.shadowColor = UIColor.black.cgColor
        mainCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainCard.layer.shadowRadius = 12
        mainCard.layer.shadowOpacity = 0.1
        mainCard.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainCard)
        
        // Logo Container (circular background)
        logoContainer = UIView()
        logoContainer.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 0.15)
        logoContainer.layer.cornerRadius = 60
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(logoContainer)
        
        // Logo Icon
        logoIcon = UIImageView()
        logoIcon.image = UIImage(systemName: "gamecontroller.fill")
        logoIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        logoIcon.contentMode = .scaleAspectFit
        logoIcon.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.addSubview(logoIcon)
        
        // Logo Label
        logoLabel = UILabel()
        logoLabel.text = "GuessChain"
        logoLabel.font = UIFont(name: "Helvetica-Bold", size: 36) ?? .systemFont(ofSize: 36, weight: .bold)
        logoLabel.textAlignment = .center
        logoLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(logoLabel)
        
        // Welcome Label
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome back!"
        welcomeLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16)
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(welcomeLabel)
        
        // Divider
        let divider = createDivider()
        mainCard.addSubview(divider)
        divider.tag = 100
        
        // Play Button
        playButton = UIButton(type: .system)
        playButton.setTitle("PLAY NOW", for: .normal)
        playButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        playButton.layer.cornerRadius = 16
        playButton.layer.shadowColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0).cgColor
        playButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        playButton.layer.shadowRadius = 8
        playButton.layer.shadowOpacity = 0.4
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let playIcon = UIImage(systemName: "play.fill")
        playButton.setImage(playIcon, for: .normal)
        playButton.tintColor = .white
        playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        mainCard.addSubview(playButton)
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }
    
    func initConstraints() {
        guard let divider = mainCard.viewWithTag(100) else { return }
        
        NSLayoutConstraint.activate([
            // Profile Button - top left
            profileButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // Logout Button - top right
            logoutButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // Main Card - centered
            mainCard.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainCard.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainCard.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            mainCard.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            // Logo Container
            logoContainer.topAnchor.constraint(equalTo: mainCard.topAnchor, constant: 40),
            logoContainer.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 120),
            logoContainer.heightAnchor.constraint(equalToConstant: 120),
            
            // Logo Icon
            logoIcon.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoIcon.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 60),
            logoIcon.heightAnchor.constraint(equalToConstant: 60),
            
            // Logo Label
            logoLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 20),
            logoLabel.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 8),
            welcomeLabel.centerXAnchor.constraint(equalTo: mainCard.centerXAnchor),
            
            // Divider
            divider.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 24),
            divider.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            
            // Play Button
            playButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            playButton.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 24),
            playButton.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -24),
            playButton.heightAnchor.constraint(equalToConstant: 60),
            playButton.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: -40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
