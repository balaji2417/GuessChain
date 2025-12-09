//
//  LeaderboardView.swift
//  WA_UI
//
//  Created by Swetha Shankara Raman on 11/17/25.
//



import UIKit

class LeaderboardView: UIView {
    
    var mainScroll: UIScrollView!
    var contentView: UIView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var podiumContainer: UIView!
    var playersContainer: UIStackView!
    var backButton: UIButton!
    
    // Podium cards
    var firstPlaceCard: UIView!
    var secondPlaceCard: UIView!
    var thirdPlaceCard: UIView!
    
    var firstPlaceLabel: UILabel!
    var secondPlaceLabel: UILabel!
    var thirdPlaceLabel: UILabel!
    
    var firstNameLabel: UILabel!
    var secondNameLabel: UILabel!
    var thirdNameLabel: UILabel!
    
    var firstScoreLabel: UILabel!
    var secondScoreLabel: UILabel!
    var thirdScoreLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupMainScroll()
        setupContentView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupPodiumContainer()
        setupPodiumCards()
        setupPlayersContainer()
        setupBackButton()
        
        initConstraints()
    }
    
    func setupMainScroll() {
        mainScroll = UIScrollView()
        mainScroll.backgroundColor = .clear
        mainScroll.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainScroll)
    }
    
    func setupContentView() {
        contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainScroll.addSubview(contentView)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Game Over!"
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 32) ?? .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func setupSubtitleLabel() {
        subtitleLabel = UILabel()
        subtitleLabel.text = "Final Scores"
        subtitleLabel.font = UIFont(name: "Menlo", size: 13) ?? .monospacedSystemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
    }
    
    func setupPodiumContainer() {
        podiumContainer = UIView()
        podiumContainer.backgroundColor = .clear
        podiumContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(podiumContainer)
    }
    
    func setupPodiumCards() {
        // First Place
        firstPlaceCard = createPodiumCard(color: UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0))
        podiumContainer.addSubview(firstPlaceCard)
        
        firstPlaceLabel = createPlaceLabel(text: "🥇")
        firstPlaceCard.addSubview(firstPlaceLabel)
        
        firstNameLabel = createNameLabel()
        firstPlaceCard.addSubview(firstNameLabel)
        
        firstScoreLabel = createScoreLabel()
        firstPlaceCard.addSubview(firstScoreLabel)
        
        // Second Place
        secondPlaceCard = createPodiumCard(color: UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0))
        podiumContainer.addSubview(secondPlaceCard)
        
        secondPlaceLabel = createPlaceLabel(text: "🥈")
        secondPlaceCard.addSubview(secondPlaceLabel)
        
        secondNameLabel = createNameLabel()
        secondPlaceCard.addSubview(secondNameLabel)
        
        secondScoreLabel = createScoreLabel()
        secondPlaceCard.addSubview(secondScoreLabel)
        
        // Third Place
        thirdPlaceCard = createPodiumCard(color: UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0))
        podiumContainer.addSubview(thirdPlaceCard)
        
        thirdPlaceLabel = createPlaceLabel(text: "🥉")
        thirdPlaceCard.addSubview(thirdPlaceLabel)
        
        thirdNameLabel = createNameLabel()
        thirdPlaceCard.addSubview(thirdNameLabel)
        
        thirdScoreLabel = createScoreLabel()
        thirdPlaceCard.addSubview(thirdScoreLabel)
    }
    
    func createPodiumCard(color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = color
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 8
        card.layer.shadowOpacity = 0.15
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
    
    func createPlaceLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createNameLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica-Bold", size: 15) ?? .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createScoreLabel() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Menlo-Bold", size: 26) ?? .monospacedSystemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupPlayersContainer() {
        playersContainer = UIStackView()
        playersContainer.axis = .vertical
        playersContainer.spacing = 10
        playersContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playersContainer)
    }
    
    func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setTitle("Back to Lobby", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        backButton.layer.cornerRadius = 14
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            mainScroll.topAnchor.constraint(equalTo: self.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScroll.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            podiumContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            podiumContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            podiumContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            podiumContainer.heightAnchor.constraint(equalToConstant: 160),
            
            firstPlaceCard.centerXAnchor.constraint(equalTo: podiumContainer.centerXAnchor),
            firstPlaceCard.topAnchor.constraint(equalTo: podiumContainer.topAnchor),
            firstPlaceCard.widthAnchor.constraint(equalToConstant: 100),
            firstPlaceCard.heightAnchor.constraint(equalToConstant: 130),
            
            firstPlaceLabel.topAnchor.constraint(equalTo: firstPlaceCard.topAnchor, constant: 14),
            firstPlaceLabel.centerXAnchor.constraint(equalTo: firstPlaceCard.centerXAnchor),
            
            firstNameLabel.centerXAnchor.constraint(equalTo: firstPlaceCard.centerXAnchor),
            firstNameLabel.centerYAnchor.constraint(equalTo: firstPlaceCard.centerYAnchor),
            
            firstScoreLabel.bottomAnchor.constraint(equalTo: firstPlaceCard.bottomAnchor, constant: -14),
            firstScoreLabel.centerXAnchor.constraint(equalTo: firstPlaceCard.centerXAnchor),
            
            secondPlaceCard.trailingAnchor.constraint(equalTo: firstPlaceCard.leadingAnchor, constant: -10),
            secondPlaceCard.topAnchor.constraint(equalTo: podiumContainer.topAnchor, constant: 30),
            secondPlaceCard.widthAnchor.constraint(equalToConstant: 90),
            secondPlaceCard.heightAnchor.constraint(equalToConstant: 110),
            
            secondPlaceLabel.topAnchor.constraint(equalTo: secondPlaceCard.topAnchor, constant: 12),
            secondPlaceLabel.centerXAnchor.constraint(equalTo: secondPlaceCard.centerXAnchor),
            
            secondNameLabel.centerXAnchor.constraint(equalTo: secondPlaceCard.centerXAnchor),
            secondNameLabel.centerYAnchor.constraint(equalTo: secondPlaceCard.centerYAnchor),
            
            secondScoreLabel.bottomAnchor.constraint(equalTo: secondPlaceCard.bottomAnchor, constant: -12),
            secondScoreLabel.centerXAnchor.constraint(equalTo: secondPlaceCard.centerXAnchor),
            
            thirdPlaceCard.leadingAnchor.constraint(equalTo: firstPlaceCard.trailingAnchor, constant: 10),
            thirdPlaceCard.topAnchor.constraint(equalTo: podiumContainer.topAnchor, constant: 50),
            thirdPlaceCard.widthAnchor.constraint(equalToConstant: 90),
            thirdPlaceCard.heightAnchor.constraint(equalToConstant: 90),
            
            thirdPlaceLabel.topAnchor.constraint(equalTo: thirdPlaceCard.topAnchor, constant: 10),
            thirdPlaceLabel.centerXAnchor.constraint(equalTo: thirdPlaceCard.centerXAnchor),
            
            thirdNameLabel.centerXAnchor.constraint(equalTo: thirdPlaceCard.centerXAnchor),
            thirdNameLabel.centerYAnchor.constraint(equalTo: thirdPlaceCard.centerYAnchor),
            
            thirdScoreLabel.bottomAnchor.constraint(equalTo: thirdPlaceCard.bottomAnchor, constant: -10),
            thirdScoreLabel.centerXAnchor.constraint(equalTo: thirdPlaceCard.centerXAnchor),
            
            playersContainer.topAnchor.constraint(equalTo: podiumContainer.bottomAnchor, constant: 24),
            playersContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            playersContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: playersContainer.bottomAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 56),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    func addPlayerCard(rank: Int, name: String, score: Int) {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let rankLabel = UILabel()
        rankLabel.text = "#\(rank)"
        rankLabel.font = UIFont(name: "Menlo-Bold", size: 18) ?? .monospacedSystemFont(ofSize: 18, weight: .bold)
        rankLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(rankLabel)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 17) ?? .systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(nameLabel)
        
        let scoreLabel = UILabel()
        scoreLabel.text = "\(score)"
        scoreLabel.font = UIFont(name: "Menlo-Bold", size: 20) ?? .monospacedSystemFont(ofSize: 20, weight: .bold)
        scoreLabel.textColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            rankLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            scoreLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            scoreLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        playersContainer.addArrangedSubview(card)
    }
    
    func clearPlayerCards() {
        playersContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
