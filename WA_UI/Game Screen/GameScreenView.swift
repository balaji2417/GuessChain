//
//  GameScreenView.swift
//  WA_UI
//
//  Created by Swetha Shankara Raman on 11/17/25.
//

//
//  GameScreenView.swift
//  GuessChain
//
//  Added: Timer label and waiting for host label
//

import UIKit

class GameScreenView: UIView {
    
    var mainScroll: UIScrollView!
    var contentContainer: UIView!
    var roundLabel: UILabel!
    var turnIndicatorLabel: UILabel!
    var timerLabel: UILabel!          // NEW
    var waitingLabel: UILabel!        // NEW
    
    // 4 Player Cards
    var playerCard1: UIView!
    var playerCard2: UIView!
    var playerCard3: UIView!
    var playerCard4: UIView!
    var playerName1: UILabel!
    var playerName2: UILabel!
    var playerName3: UILabel!
    var playerName4: UILabel!
    var playerScore1: UILabel!
    var playerScore2: UILabel!
    var playerScore3: UILabel!
    var playerScore4: UILabel!
    
    // Question card
    var questionCard: UIView!
    var questionLabel: UILabel!
    var questionIconBg: UIView!
    var questionIcon: UILabel!
    
    // Answer display
    var answerDisplayCard: UIView!
    var answerDisplayLabel: UILabel!
    
    // Input
    var answerField: UITextField!
    var submitBtn: UIButton!
    
    // Start button
    var startGameBtn: UIButton!
    
    // Shake hint
    var shakeHintLabel: UILabel!
    
    // Start overlay
    var startOverlay: UIVisualEffectView!
    var startBanner: UIView!
    
    // Waiting overlay (separate for non-owners)
    var waitingOverlay: UIVisualEffectView!
    var waitingBanner: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupMainScroll()
        setupContentContainer()
        setupRoundLabel()
        setupTurnIndicator()
        setupTimerLabel()          // NEW
        setupWaitingLabel()        // NEW
        setupPlayerCards()
        setupQuestionCard()
        setupAnswerDisplay()
        setupAnswerField()
        setupSubmitBtn()
        setupStartGameBtn()
        setupShakeHint()
        setupStartOverlay()
        setupWaitingOverlay()  // NEW
        
        initConstraints()
    }
    
    func setupMainScroll() {
        mainScroll = UIScrollView()
        mainScroll.backgroundColor = .clear
        mainScroll.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainScroll)
    }
    
    func setupContentContainer() {
        contentContainer = UIView()
        contentContainer.backgroundColor = .clear
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        mainScroll.addSubview(contentContainer)
    }
    
    func setupRoundLabel() {
        roundLabel = UILabel()
        roundLabel.text = "Question 1 of 5"
        roundLabel.font = UIFont(name: "Menlo-Bold", size: 13) ?? .monospacedSystemFont(ofSize: 13, weight: .bold)
        roundLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        roundLabel.textAlignment = .center
        roundLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(roundLabel)
    }
    
    func setupTurnIndicator() {
        turnIndicatorLabel = UILabel()
        turnIndicatorLabel.text = "YOUR TURN"
        turnIndicatorLabel.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        turnIndicatorLabel.textColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        turnIndicatorLabel.textAlignment = .center
        turnIndicatorLabel.alpha = 0
        turnIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(turnIndicatorLabel)
    }
    
    func setupTimerLabel() {
        timerLabel = UILabel()
        timerLabel.text = "30"
        timerLabel.font = UIFont(name: "Menlo-Bold", size: 24) ?? .monospacedSystemFont(ofSize: 24, weight: .bold)
        timerLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        timerLabel.textAlignment = .center
        timerLabel.alpha = 0
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(timerLabel)
    }
    
    func setupWaitingLabel() {
        waitingLabel = UILabel()
        waitingLabel.text = "Waiting for host to start..."
        waitingLabel.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16, weight: .regular)
        waitingLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        waitingLabel.textAlignment = .center
        waitingLabel.numberOfLines = 0
        waitingLabel.alpha = 0
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(waitingLabel)
    }
    
    func setupPlayerCards() {
        playerCard1 = createPlayerCard()
        contentContainer.addSubview(playerCard1)
        playerName1 = createPlayerNameLabel()
        playerCard1.addSubview(playerName1)
        playerScore1 = createPlayerScoreLabel()
        playerCard1.addSubview(playerScore1)
        
        playerCard2 = createPlayerCard()
        contentContainer.addSubview(playerCard2)
        playerName2 = createPlayerNameLabel()
        playerCard2.addSubview(playerName2)
        playerScore2 = createPlayerScoreLabel()
        playerCard2.addSubview(playerScore2)
        
        playerCard3 = createPlayerCard()
        contentContainer.addSubview(playerCard3)
        playerName3 = createPlayerNameLabel()
        playerCard3.addSubview(playerName3)
        playerScore3 = createPlayerScoreLabel()
        playerCard3.addSubview(playerScore3)
        
        playerCard4 = createPlayerCard()
        contentContainer.addSubview(playerCard4)
        playerName4 = createPlayerNameLabel()
        playerCard4.addSubview(playerName4)
        playerScore4 = createPlayerScoreLabel()
        playerCard4.addSubview(playerScore4)
    }
    
    func createPlayerCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
    
    func createPlayerNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "Empty"
        label.font = UIFont(name: "Helvetica-Bold", size: 12) ?? .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createPlayerScoreLabel() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Menlo-Bold", size: 24) ?? .monospacedSystemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupQuestionCard() {
        questionCard = UIView()
        questionCard.backgroundColor = .white
        questionCard.layer.cornerRadius = 20
        questionCard.layer.borderWidth = 2
        questionCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        questionCard.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(questionCard)
        
        questionIconBg = UIView()
        questionIconBg.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 0.15)
        questionIconBg.layer.cornerRadius = 16
        questionIconBg.translatesAutoresizingMaskIntoConstraints = false
        questionCard.addSubview(questionIconBg)
        
        questionIcon = UILabel()
        questionIcon.text = "?"
        questionIcon.font = UIFont(name: "Helvetica-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        questionIcon.textColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        questionIcon.textAlignment = .center
        questionIcon.translatesAutoresizingMaskIntoConstraints = false
        questionIconBg.addSubview(questionIcon)
        
        questionLabel = UILabel()
        questionLabel.text = "Waiting for game to start..."
        questionLabel.font = UIFont(name: "Helvetica-Bold", size: 19) ?? .systemFont(ofSize: 19, weight: .bold)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 3
        questionLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionCard.addSubview(questionLabel)
    }
    
    func setupAnswerDisplay() {
        answerDisplayCard = UIView()
        answerDisplayCard.backgroundColor = .white
        answerDisplayCard.layer.cornerRadius = 14
        answerDisplayCard.alpha = 0
        answerDisplayCard.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(answerDisplayCard)
        
        answerDisplayLabel = UILabel()
        answerDisplayLabel.text = ""
        answerDisplayLabel.font = UIFont(name: "Helvetica-Bold", size: 17) ?? .systemFont(ofSize: 17, weight: .bold)
        answerDisplayLabel.textAlignment = .center
        answerDisplayLabel.numberOfLines = 0
        answerDisplayLabel.textColor = .white
        answerDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        answerDisplayCard.addSubview(answerDisplayLabel)
    }
    
    func setupAnswerField() {
        answerField = UITextField()
        answerField.placeholder = "Waiting for your turn..."
        answerField.font = UIFont(name: "Helvetica", size: 17) ?? .systemFont(ofSize: 17)
        answerField.textAlignment = .center
        answerField.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        answerField.backgroundColor = .white
        answerField.layer.cornerRadius = 14
        answerField.layer.borderWidth = 2
        answerField.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        answerField.isEnabled = false
        answerField.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(answerField)
    }
    
    func setupSubmitBtn() {
        submitBtn = UIButton(type: .system)
        submitBtn.setTitle("Submit Answer", for: .normal)
        submitBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17) ?? .systemFont(ofSize: 17, weight: .bold)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        submitBtn.layer.cornerRadius = 14
        submitBtn.isEnabled = false
        submitBtn.alpha = 0.4
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(submitBtn)
    }
    
    func setupStartGameBtn() {
        startGameBtn = UIButton(type: .system)
        startGameBtn.setTitle("Start Game", for: .normal)
        startGameBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        startGameBtn.setTitleColor(.white, for: .normal)
        startGameBtn.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        startGameBtn.layer.cornerRadius = 16
        startGameBtn.layer.shadowColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 0.4).cgColor
        startGameBtn.layer.shadowOffset = CGSize(width: 0, height: 4)
        startGameBtn.layer.shadowRadius = 12
        startGameBtn.layer.shadowOpacity = 0.5
        startGameBtn.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupShakeHint() {
        shakeHintLabel = UILabel()
        
        let shakeText = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        attachment.image = UIImage(systemName: "iphone.gen3.radiowaves.left.and.right", withConfiguration: config)?.withTintColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), renderingMode: .alwaysOriginal)
        shakeText.append(NSAttributedString(attachment: attachment))
        shakeText.append(NSAttributedString(string: "  shake to skip", attributes: [
            .font: UIFont(name: "Menlo", size: 12) ?? .monospacedSystemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        ]))
        
        shakeHintLabel.attributedText = shakeText
        shakeHintLabel.textAlignment = .center
        shakeHintLabel.alpha = 0
        shakeHintLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(shakeHintLabel)
        
        let shake = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        shake.values = [0, -0.03, 0.03, -0.03, 0.03, 0]
        shake.duration = 2.0
        shake.repeatCount = .infinity
        shakeHintLabel.layer.add(shake, forKey: "shake")
    }
    
    func setupStartOverlay() {
        startOverlay = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        startOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(startOverlay)
        
        startBanner = UIView()
        startBanner.backgroundColor = .white
        startBanner.layer.cornerRadius = 28
        startBanner.layer.shadowColor = UIColor.black.cgColor
        startBanner.layer.shadowOffset = CGSize(width: 0, height: 15)
        startBanner.layer.shadowRadius = 40
        startBanner.layer.shadowOpacity = 0.4
        startBanner.translatesAutoresizingMaskIntoConstraints = false
        startOverlay.contentView.addSubview(startBanner)
        
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 0.15)
        iconBg.layer.cornerRadius = 35
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.tag = 104
        startBanner.addSubview(iconBg)
        
        let iconLabel = UILabel()
        iconLabel.text = "🎮"
        iconLabel.font = .systemFont(ofSize: 40)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.tag = 105
        iconBg.addSubview(iconLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = "Ready to Play?"
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 26) ?? .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.tag = 102
        startBanner.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Tap below to begin"
        subtitleLabel.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.tag = 103
        startBanner.addSubview(subtitleLabel)
        
        startBanner.addSubview(startGameBtn)
        
        startOverlay.isHidden = true
    }
    
    func setupWaitingOverlay() {
        // Separate overlay for non-owners
        waitingOverlay = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        waitingOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(waitingOverlay)
        
        waitingBanner = UIView()
        waitingBanner.backgroundColor = .white
        waitingBanner.layer.cornerRadius = 28
        waitingBanner.layer.shadowColor = UIColor.black.cgColor
        waitingBanner.layer.shadowOffset = CGSize(width: 0, height: 15)
        waitingBanner.layer.shadowRadius = 40
        waitingBanner.layer.shadowOpacity = 0.4
        waitingBanner.translatesAutoresizingMaskIntoConstraints = false
        waitingOverlay.contentView.addSubview(waitingBanner)
        
        // Icon
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.15)
        iconBg.layer.cornerRadius = 35
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        iconBg.tag = 204
        waitingBanner.addSubview(iconBg)
        
        let iconLabel = UILabel()
        iconLabel.text = "⏳"
        iconLabel.font = .systemFont(ofSize: 40)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.tag = 205
        iconBg.addSubview(iconLabel)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Waiting for Host"
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 26) ?? .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.tag = 202
        waitingBanner.addSubview(titleLabel)
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "The host will start the game soon"
        subtitleLabel.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.tag = 203
        waitingBanner.addSubview(subtitleLabel)
        
        waitingOverlay.isHidden = true
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            mainScroll.topAnchor.constraint(equalTo: self.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentContainer.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: mainScroll.widthAnchor),
            
            roundLabel.topAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.topAnchor, constant: 12),
            roundLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            turnIndicatorLabel.topAnchor.constraint(equalTo: roundLabel.bottomAnchor, constant: 4),
            turnIndicatorLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: turnIndicatorLabel.bottomAnchor, constant: 4),
            timerLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            waitingLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            waitingLabel.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            waitingLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 40),
            waitingLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -40),
            
            // Player Cards
            playerCard1.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 12),
            playerCard1.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            playerCard1.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.44),
            playerCard1.heightAnchor.constraint(equalToConstant: 75),
            
            playerCard2.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 12),
            playerCard2.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            playerCard2.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.44),
            playerCard2.heightAnchor.constraint(equalToConstant: 75),
            
            playerCard3.topAnchor.constraint(equalTo: playerCard1.bottomAnchor, constant: 10),
            playerCard3.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            playerCard3.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.44),
            playerCard3.heightAnchor.constraint(equalToConstant: 75),
            
            playerCard4.topAnchor.constraint(equalTo: playerCard2.bottomAnchor, constant: 10),
            playerCard4.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            playerCard4.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.44),
            playerCard4.heightAnchor.constraint(equalToConstant: 75),
            
            playerName1.topAnchor.constraint(equalTo: playerCard1.topAnchor, constant: 10),
            playerName1.centerXAnchor.constraint(equalTo: playerCard1.centerXAnchor),
            playerScore1.bottomAnchor.constraint(equalTo: playerCard1.bottomAnchor, constant: -10),
            playerScore1.centerXAnchor.constraint(equalTo: playerCard1.centerXAnchor),
            
            playerName2.topAnchor.constraint(equalTo: playerCard2.topAnchor, constant: 10),
            playerName2.centerXAnchor.constraint(equalTo: playerCard2.centerXAnchor),
            playerScore2.bottomAnchor.constraint(equalTo: playerCard2.bottomAnchor, constant: -10),
            playerScore2.centerXAnchor.constraint(equalTo: playerCard2.centerXAnchor),
            
            playerName3.topAnchor.constraint(equalTo: playerCard3.topAnchor, constant: 10),
            playerName3.centerXAnchor.constraint(equalTo: playerCard3.centerXAnchor),
            playerScore3.bottomAnchor.constraint(equalTo: playerCard3.bottomAnchor, constant: -10),
            playerScore3.centerXAnchor.constraint(equalTo: playerCard3.centerXAnchor),
            
            playerName4.topAnchor.constraint(equalTo: playerCard4.topAnchor, constant: 10),
            playerName4.centerXAnchor.constraint(equalTo: playerCard4.centerXAnchor),
            playerScore4.bottomAnchor.constraint(equalTo: playerCard4.bottomAnchor, constant: -10),
            playerScore4.centerXAnchor.constraint(equalTo: playerCard4.centerXAnchor),
            
            // Question Card
            questionCard.topAnchor.constraint(equalTo: playerCard3.bottomAnchor, constant: 16),
            questionCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            questionCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            questionCard.heightAnchor.constraint(equalToConstant: 115),
            
            questionIconBg.topAnchor.constraint(equalTo: questionCard.topAnchor, constant: 12),
            questionIconBg.centerXAnchor.constraint(equalTo: questionCard.centerXAnchor),
            questionIconBg.widthAnchor.constraint(equalToConstant: 32),
            questionIconBg.heightAnchor.constraint(equalToConstant: 32),
            
            questionIcon.centerXAnchor.constraint(equalTo: questionIconBg.centerXAnchor),
            questionIcon.centerYAnchor.constraint(equalTo: questionIconBg.centerYAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: questionIconBg.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: questionCard.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: questionCard.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: -12),
            
            answerDisplayCard.topAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: 14),
            answerDisplayCard.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            answerDisplayCard.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.7),
            answerDisplayCard.heightAnchor.constraint(equalToConstant: 46),
            
            answerDisplayLabel.centerXAnchor.constraint(equalTo: answerDisplayCard.centerXAnchor),
            answerDisplayLabel.centerYAnchor.constraint(equalTo: answerDisplayCard.centerYAnchor),
            answerDisplayLabel.leadingAnchor.constraint(equalTo: answerDisplayCard.leadingAnchor, constant: 16),
            answerDisplayLabel.trailingAnchor.constraint(equalTo: answerDisplayCard.trailingAnchor, constant: -16),
            
            answerField.topAnchor.constraint(equalTo: answerDisplayCard.bottomAnchor, constant: 14),
            answerField.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            answerField.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            answerField.heightAnchor.constraint(equalToConstant: 48),
            
            submitBtn.topAnchor.constraint(equalTo: answerField.bottomAnchor, constant: 10),
            submitBtn.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            submitBtn.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            submitBtn.heightAnchor.constraint(equalToConstant: 48),
            
            shakeHintLabel.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 10),
            shakeHintLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            shakeHintLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -20),
            
            // Start Overlay
            startOverlay.topAnchor.constraint(equalTo: self.topAnchor),
            startOverlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            startOverlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            startOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            startBanner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startBanner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            startBanner.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            startBanner.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
        
        if let iconBg = startBanner.viewWithTag(104),
           let iconLabel = startBanner.viewWithTag(105),
           let titleLabel = startBanner.viewWithTag(102),
           let subtitleLabel = startBanner.viewWithTag(103) {
            NSLayoutConstraint.activate([
                iconBg.topAnchor.constraint(equalTo: startBanner.topAnchor, constant: 30),
                iconBg.centerXAnchor.constraint(equalTo: startBanner.centerXAnchor),
                iconBg.widthAnchor.constraint(equalToConstant: 70),
                iconBg.heightAnchor.constraint(equalToConstant: 70),
                
                iconLabel.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
                iconLabel.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
                
                titleLabel.topAnchor.constraint(equalTo: iconBg.bottomAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: startBanner.centerXAnchor),
                
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
                subtitleLabel.centerXAnchor.constraint(equalTo: startBanner.centerXAnchor),
                
                startGameBtn.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
                startGameBtn.centerXAnchor.constraint(equalTo: startBanner.centerXAnchor),
                startGameBtn.leadingAnchor.constraint(equalTo: startBanner.leadingAnchor, constant: 40),
                startGameBtn.trailingAnchor.constraint(equalTo: startBanner.trailingAnchor, constant: -40),
                startGameBtn.heightAnchor.constraint(equalToConstant: 56),
                startGameBtn.bottomAnchor.constraint(equalTo: startBanner.bottomAnchor, constant: -30)
            ])
        }
        
        // Waiting overlay constraints
        NSLayoutConstraint.activate([
            waitingOverlay.topAnchor.constraint(equalTo: self.topAnchor),
            waitingOverlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            waitingOverlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            waitingOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            waitingBanner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            waitingBanner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            waitingBanner.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            waitingBanner.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
        
        if let iconBg = waitingBanner.viewWithTag(204),
           let iconLabel = waitingBanner.viewWithTag(205),
           let titleLabel = waitingBanner.viewWithTag(202),
           let subtitleLabel = waitingBanner.viewWithTag(203) {
            NSLayoutConstraint.activate([
                iconBg.topAnchor.constraint(equalTo: waitingBanner.topAnchor, constant: 30),
                iconBg.centerXAnchor.constraint(equalTo: waitingBanner.centerXAnchor),
                iconBg.widthAnchor.constraint(equalToConstant: 70),
                iconBg.heightAnchor.constraint(equalToConstant: 70),
                
                iconLabel.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
                iconLabel.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
                
                titleLabel.topAnchor.constraint(equalTo: iconBg.bottomAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: waitingBanner.centerXAnchor),
                
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                subtitleLabel.centerXAnchor.constraint(equalTo: waitingBanner.centerXAnchor),
                subtitleLabel.leadingAnchor.constraint(equalTo: waitingBanner.leadingAnchor, constant: 30),
                subtitleLabel.trailingAnchor.constraint(equalTo: waitingBanner.trailingAnchor, constant: -30),
                subtitleLabel.bottomAnchor.constraint(equalTo: waitingBanner.bottomAnchor, constant: -30)
            ])
        }
    }
    
    // MARK: - Helper Methods
    
    func highlightPlayerCard(_ index: Int) {
        [playerCard1, playerCard2, playerCard3, playerCard4].forEach {
            $0?.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
            $0?.layer.borderWidth = 2
            $0?.transform = .identity
        }
        
        let cards = [playerCard1, playerCard2, playerCard3, playerCard4]
        if index < cards.count, let card = cards[index] {
            UIView.animate(withDuration: 0.3) {
                card.layer.borderColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0).cgColor
                card.layer.borderWidth = 3
                card.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }
    }
    
    func updatePlayerCard(index: Int, name: String, score: Int) {
        let nameLabels = [playerName1, playerName2, playerName3, playerName4]
        let scoreLabels = [playerScore1, playerScore2, playerScore3, playerScore4]
        
        if index < nameLabels.count {
            nameLabels[index]?.text = name
            scoreLabels[index]?.text = "\(score)"
        }
    }
    
    func showAnswerAnimation(answer: String, isCorrect: Bool) {
        answerDisplayLabel.text = answer
        answerDisplayCard.backgroundColor = isCorrect ?
            UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0) :
            UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.answerDisplayCard.alpha = 1
            self.answerDisplayCard.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.answerDisplayCard.transform = .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 1.0) {
                    self.answerDisplayCard.alpha = 0
                }
            }
        }
    }
    
    func showTurnIndicator(_ text: String) {
        turnIndicatorLabel.text = text
        UIView.animate(withDuration: 0.3) {
            self.turnIndicatorLabel.alpha = 1
        }
    }
    
    func hideTurnIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.turnIndicatorLabel.alpha = 0
        }
    }
    
    func showShakeHint() {
        UIView.animate(withDuration: 0.4) {
            self.shakeHintLabel.alpha = 1
        }
    }
    
    func hideShakeHint() {
        UIView.animate(withDuration: 0.3) {
            self.shakeHintLabel.alpha = 0
        }
    }
    
    func showTimer(_ time: Int) {
        timerLabel.text = "\(time)"
        timerLabel.textColor = time <= 10 ?
            UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0) :
            UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        UIView.animate(withDuration: 0.2) {
            self.timerLabel.alpha = 1
        }
    }
    
    func hideTimer() {
        UIView.animate(withDuration: 0.2) {
            self.timerLabel.alpha = 0
        }
    }
    
    func showWaitingForHost() {
        // Show separate waiting overlay
        waitingOverlay.isHidden = false
        waitingOverlay.alpha = 0
        waitingBanner.alpha = 0
        waitingBanner.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        UIView.animate(withDuration: 0.5) {
            self.waitingOverlay.alpha = 1
            self.waitingBanner.alpha = 1
            self.waitingBanner.transform = .identity
        }
    }
    
    func hideWaitingForHost() {
        UIView.animate(withDuration: 0.3) {
            self.waitingOverlay.alpha = 0
        } completion: { _ in
            self.waitingOverlay.isHidden = true
        }
    }
    
    func showStartOverlay() {
        guard startOverlay.isHidden else { return }
        
        startOverlay.isHidden = false
        startOverlay.alpha = 0
        startBanner.alpha = 0
        startBanner.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.startOverlay.alpha = 1
            self.startBanner.alpha = 1
            self.startBanner.transform = .identity
        }
    }
    
    func hideStartOverlay(completion: @escaping () -> Void) {
        startGameBtn.isEnabled = false
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut], animations: {
            self.startOverlay.alpha = 0
            self.startBanner.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            self.startOverlay.isHidden = true
            self.startBanner.transform = .identity
            self.startGameBtn.isEnabled = true
            completion()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
