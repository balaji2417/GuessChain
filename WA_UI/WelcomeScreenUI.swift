//
//  WelcomeScreenUI.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class WelcomeScreenUI: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var logoContainer: UIView!
    var logoLabel: UILabel!
    var playButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLogoContainer()
        setupLogoLabel()
        setupPlayButton()
        
        initConstraints()
    }
    
    func setupLogoContainer() {
        logoContainer = UIView()
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoContainer)
    }
    
    func setupLogoLabel() {
        logoLabel = UILabel()
        logoLabel.text = "LOGO"
        logoLabel.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.addSubview(logoLabel)
    }
    
    func setupPlayButton() {
        playButton = UIButton(type: .system)
        playButton.setTitle("PLAY NOW", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            logoContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -80),
            logoContainer.widthAnchor.constraint(equalToConstant: 180),
            logoContainer.heightAnchor.constraint(equalToConstant: 180),
            
            logoLabel.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 60),
            playButton.widthAnchor.constraint(equalToConstant: 240),
            playButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
