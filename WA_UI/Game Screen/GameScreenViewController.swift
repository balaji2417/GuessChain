//
//  GameScreenViewController.swift
//  WA_UI
//
//  Created by Swetha Shankara Raman on 11/17/25.
//


import UIKit
import FirebaseFirestore

class GameScreenViewController: UIViewController {
    
    var gameView: GameScreenView!
    var roomId: String = ""
    var myPlayerId: String = ""
    var myPlayerIndex: Int = -1
    var isOwner: Bool = false
    
    private var listener: ListenerRegistration?
    private var timer: Timer?
    private var timeRemaining: Int = 30
    private var previousPlayerCount: Int = 0
    private var previousPlayerIds: Set<String> = []  // Track who was in the room
    private var hasShownHostLeftAlert: Bool = false  // Prevent multiple alerts
    
    private var currentPlayers: [Player] = []
    private var currentQuestionIds: [String] = []
    private var currentQuestion: Question?
    private var currentQuestionIndex: Int = 0
    private var currentPlayerTurnIndex: Int = 0
    private var gameStatus: String = "waiting"
    private var roomOwnerId: String = ""
    
    override func loadView() {
        gameView = GameScreenView()
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Game Room"
        navigationItem.hidesBackButton = true
        
        let leaveBtn = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(leaveGame))
        leaveBtn.tintColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        navigationItem.rightBarButtonItem = leaveBtn
        
        gameView.submitBtn.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        gameView.startGameBtn.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        becomeFirstResponder()
        setupRoomListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            handleShakeGesture()
        }
    }
    
    // MARK: - Shake to Skip
    
    func handleShakeGesture() {
        guard gameStatus == "in_progress" else { return }
        guard currentPlayers.count > 0 else { return }
        
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        guard currentPlayerIndex == myPlayerIndex else { return }
        
        let alert = UIAlertController(title: "Skip Question?", message: "Skip this question?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Skip", style: .destructive) { [weak self] _ in
            self?.skipQuestion()
        })
        present(alert, animated: true)
    }
    
    func skipQuestion() {
        timer?.invalidate()
        gameView.hideTimer()
        submitAnswerToFirestore("Skipped")
    }
    
    // MARK: - Firestore Listener
    
    func setupRoomListener() {
        let db = Firestore.firestore()
        
        listener = db.collection("lobby").document(roomId).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error listening to room: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Room deleted")
                // NO POPUP - just go back silently
                DispatchQueue.main.async {
                    self.listener?.remove()
                    self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                }
                return
            }
            
            self.handleRoomUpdate(data: data)
        }
    }
    
    func handleRoomUpdate(data: [String: Any]) {
        // Get room owner
        roomOwnerId = data["createdBy"] as? String ?? ""
        isOwner = (roomOwnerId == myPlayerId)
        
        // Parse players
        var newPlayerCount = 0
        var newPlayerIds: Set<String> = []
        
        if let playersData = data["players"] as? [[String: Any]] {
            currentPlayers = []
            
            for playerData in playersData {
                let id = playerData["id"] as? String ?? ""
                let name = playerData["name"] as? String ?? ""
                let score = playerData["score"] as? Int ?? 0
                
                if !id.isEmpty && !name.isEmpty {
                    let player = Player(name: name, id: id, score: score)
                    currentPlayers.append(player)
                    newPlayerIds.insert(id)
                    
                    if id == myPlayerId {
                        myPlayerIndex = currentPlayers.count - 1
                    }
                }
            }
            
            newPlayerCount = currentPlayers.count
            updatePlayerCards()
        }
        
        let newGameStatus = data["gameStatus"] as? String ?? "waiting"
        let statusChanged = newGameStatus != gameStatus
        gameStatus = newGameStatus
        
        // Check if owner is actually in the room (only if we haven't shown alert yet)
        if gameStatus == "waiting" && !isOwner && !hasShownHostLeftAlert {
            let ownerInRoom = currentPlayers.contains { $0.id == roomOwnerId }
            
            // Check if roomOwnerId is empty OR owner not in room
            if roomOwnerId.isEmpty || !ownerInRoom {
                hasShownHostLeftAlert = true
                
                // First show waiting for host background
                gameView.startOverlay.isHidden = true
                gameView.showWaitingForHost()
                
                // Then show alert on top with slight delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showAlert(message: "Host has left the room") {
                        self.listener?.remove()
                        
                        // Remove self from room
                        let db = Firestore.firestore()
                        db.collection("lobby").document(self.roomId).getDocument { snapshot, error in
                            guard var players = snapshot?.data()?["players"] as? [[String: Any]] else {
                                DispatchQueue.main.async {
                                    self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                                }
                                return
                            }
                            
                            players.removeAll { $0["id"] as? String == self.myPlayerId }
                            
                            db.collection("lobby").document(self.roomId).updateData(["players": players]) { _ in
                                DispatchQueue.main.async {
                                    self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                                }
                            }
                        }
                    }
                }
                return
            }
        }
        
        // Check if owner left during game
        if gameStatus == "in_progress" && newPlayerCount == 1 && !isOwner {
            // You're the only one left - end game
            timer?.invalidate()
            gameView.hideTimer()
            showAlert(message: "Other players have left. You win!") {
                self.listener?.remove()
                self.navigateToLeaderboard()
            }
            return
        }
        
        // Check if only 1 player remains during game
        if gameStatus == "in_progress" && newPlayerCount == 1 {
            // End game immediately
            timer?.invalidate()
            gameView.hideTimer()
            
            let db = Firestore.firestore()
            db.collection("lobby").document(self.roomId).updateData([
                "gameStatus": "completed"
            ]) { _ in
                // Listener will handle navigation to leaderboard
            }
            return
        }
        
        // Detect if someone left during game
        if gameStatus == "in_progress" && previousPlayerCount > 0 {
            // Check who left
            let playersWhoLeft = previousPlayerIds.subtracting(newPlayerIds)
            
            if !playersWhoLeft.isEmpty {
                // Someone left!
                showTemporaryBanner("Player left the game")
                
                // Check if it was the current player's turn
                if currentPlayers.count > 0 {
                    let currentPlayerIndex = currentPlayerTurnIndex % max(previousPlayerCount, 1)
                    
                    // Get who SHOULD be playing now based on old player count
                    // If that player is gone, skip immediately
                    var needsSkip = false
                    
                    // Simple check: if current turn player isn't in new player list, skip
                    if currentPlayerIndex < currentPlayers.count {
                        // Player is still there, all good
                    } else {
                        // Turn index is out of bounds, need to skip
                        needsSkip = true
                    }
                    
                    // Or check if the player at current turn index just left
                    for leftPlayerId in playersWhoLeft {
                        // If it might have been their turn, skip
                        needsSkip = true
                        break
                    }
                    
                    if needsSkip {
                        print("Player whose turn it was left - skipping NOW")
                        timer?.invalidate()
                        gameView.hideTimer()
                        
                        // Skip to next valid player immediately
                        GameManager.shared.moveToNextTurn(
                            roomId: roomId,
                            questionIds: currentQuestionIds,
                            playerId: "",
                            wasCorrect: false
                        ) { _, _ in
                            print("Skipped absent player's turn")
                        }
                    }
                }
            }
        }
        
        previousPlayerCount = newPlayerCount
        previousPlayerIds = newPlayerIds
        
        if let questionIds = data["questionIds"] as? [String] {
            currentQuestionIds = questionIds
        }
        
        let newQuestionIndex = data["currentQuestionIndex"] as? Int ?? 0
        let newPlayerTurnIndex = data["currentPlayerTurnIndex"] as? Int ?? 0
        
        let questionChanged = newQuestionIndex != currentQuestionIndex
        let turnChanged = newPlayerTurnIndex != currentPlayerTurnIndex
        
        currentQuestionIndex = newQuestionIndex
        currentPlayerTurnIndex = newPlayerTurnIndex
        
        if let questionData = data["currentQuestion"] as? [String: Any],
           let qId = questionData["id"] as? String,
           let qText = questionData["question"] as? String,
           let qAnswer = questionData["answer"] as? String {
            currentQuestion = Question(id: qId, question: qText, answer: qAnswer)
        }
        
        // Update UI
        switch gameStatus {
        case "waiting":
            if isOwner {
                // Owner sees start overlay with button
                gameView.hideWaitingForHost()
                gameView.showStartOverlay()
                
                if currentPlayers.count >= 2 {
                    gameView.startGameBtn.setTitle("Start Game", for: .normal)
                    gameView.startGameBtn.isEnabled = true
                    gameView.startGameBtn.alpha = 1.0
                } else {
                    gameView.startGameBtn.setTitle("Need 2+ Players", for: .normal)
                    gameView.startGameBtn.isEnabled = false
                    gameView.startGameBtn.alpha = 0.5
                }
            } else {
                // Non-owner sees waiting overlay (no button)
                gameView.startOverlay.isHidden = true
                gameView.showWaitingForHost()
            }
            gameView.questionLabel.text = "Waiting for game to start..."
            gameView.roundLabel.text = "Get ready!"
            disableInput()
            
        case "in_progress":
            gameView.startOverlay.isHidden = true
            gameView.hideWaitingForHost()
            updateGameUI()
            
            if turnChanged || statusChanged || questionChanged {
                checkTurn()
            }
            
        case "completed":
            timer?.invalidate()
            gameView.hideTimer()
            disableInput()
            gameView.hideTurnIndicator()
            navigateToLeaderboard()
            
        default:
            break
        }
    }
    
    func updatePlayerCards() {
        let allCards = [gameView.playerCard1, gameView.playerCard2, gameView.playerCard3, gameView.playerCard4]
        
        allCards.forEach { $0?.isHidden = true }
        
        for (index, player) in currentPlayers.enumerated() {
            if index < 4 {
                allCards[index]?.isHidden = false
                let displayName = (index == myPlayerIndex) ? "YOU" : player.name
                gameView.updatePlayerCard(index: index, name: displayName, score: player.score)
            }
        }
    }
    
    func updateGameUI() {
        if let question = currentQuestion {
            gameView.questionLabel.text = question.question
        }
        
        gameView.roundLabel.text = "Question \(currentQuestionIndex + 1) of 5"
        
        if currentPlayers.count > 0 {
            let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
            gameView.highlightPlayerCard(currentPlayerIndex)
        }
    }
    
    // MARK: - Turn Management
    
    func checkTurn() {
        guard currentPlayers.count > 0 else { return }
        
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        let currentPlayer = currentPlayers[currentPlayerIndex]
        
        // Start timer for everyone to see
        startTimer()
        
        if currentPlayerIndex == myPlayerIndex {
            // My turn!
            enableInput()
            gameView.showTurnIndicator("YOUR TURN")
        } else {
            // Someone else's turn
            gameView.showTurnIndicator("\(currentPlayer.name)'s Turn")
            disableInput()
        }
    }
    
    func autoSkipToNextPlayer() {
        // This function is no longer needed - timeout monitor handles it
    }
    
    func enableInput() {
        DispatchQueue.main.async {
            self.gameView.answerField.isEnabled = true
            self.gameView.answerField.text = ""
            self.gameView.answerField.placeholder = "Type your answer"
            self.gameView.submitBtn.isEnabled = true
            self.gameView.submitBtn.alpha = 1.0
            self.gameView.answerField.becomeFirstResponder()
            self.gameView.showShakeHint()
        }
    }
    
    func disableInput() {
        gameView.answerField.isEnabled = false
        gameView.answerField.text = ""
        gameView.answerField.placeholder = "Waiting..."
        gameView.submitBtn.isEnabled = false
        gameView.submitBtn.alpha = 0.4
        gameView.answerField.resignFirstResponder()
        gameView.hideShakeHint()
    }
    
    // MARK: - Timer (Shows for ALL players)
    
    func startTimer() {
        timeRemaining = 30
        gameView.showTimer(timeRemaining)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            self.gameView.showTimer(self.timeRemaining)
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.handleTimeout()
            }
        }
    }
    
    func handleTimeout() {
        gameView.hideTimer()
        
        guard currentPlayers.count > 0 else { return }
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        
        if currentPlayerIndex == myPlayerIndex {
            // It was MY turn - auto submit, NO POPUP
            disableInput()
            submitAnswerToFirestore("Timeout")
        }
        // If it's someone else's turn, do nothing - GameManager will handle auto-skip
    }
    
    // MARK: - Actions
    
    @objc func startGame() {
        guard currentPlayers.count >= 2 else {
            showAlert(message: "Need at least 2 players to start")
            return
        }
        
        guard isOwner else {
            showAlert(message: "Only the host can start the game")
            return
        }
        
        gameView.startGameBtn.isEnabled = false
        
        gameView.hideStartOverlay {
            print("Game starting...")
        }
        
        GameManager.shared.startGame(roomId: roomId) { [weak self] success, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(message: error)
                    self?.gameView.showStartOverlay()
                    self?.gameView.startGameBtn.isEnabled = true
                }
            }
        }
    }
    
    @objc func submitAnswer() {
        guard let answerText = gameView.answerField.text?.trimmingCharacters(in: .whitespaces),
              !answerText.isEmpty else {
            showAlert(message: "Please enter an answer")
            return
        }
        
        timer?.invalidate()
        gameView.hideTimer()
        submitAnswerToFirestore(answerText)
    }
    
    func submitAnswerToFirestore(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        disableInput()
        
        GameManager.shared.submitAnswer(
            roomId: roomId,
            playerId: myPlayerId,
            answer: answer,
            currentQuestionIndex: currentQuestionIndex,
            currentQuestion: question
        ) { [weak self] success, isCorrect, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.showAlert(message: error)
                    return
                }
                
                self.gameView.showAnswerAnimation(answer: answer, isCorrect: isCorrect)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    GameManager.shared.moveToNextTurn(
                        roomId: self.roomId,
                        questionIds: self.currentQuestionIds,
                        playerId: self.myPlayerId,
                        wasCorrect: isCorrect
                    ) { success, error in
                        if let error = error {
                            print("Error: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func navigateToLeaderboard() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                
                // Remove listener to freeze scores - no more live updates
                self.listener?.remove()
                
                let leaderboardVC = LeaderboardViewController()
                leaderboardVC.roomId = self.roomId
                leaderboardVC.players = self.currentPlayers  // Frozen snapshot of final scores
                leaderboardVC.myPlayerId = self.myPlayerId
                self.navigationController?.pushViewController(leaderboardVC, animated: true)
            }
    }
    
    @objc func leaveGame() {
        let alert = UIAlertController(title: "Leave Game?", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.handleLeave()
        })
        present(alert, animated: true)
    }
    
    func handleLeave() {
        listener?.remove()
        
        let db = Firestore.firestore()
        let roomRef = db.collection("lobby").document(roomId)
        
        roomRef.getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  var players = data["players"] as? [[String: Any]] else {
                // Just go back, no popup
                DispatchQueue.main.async {
                    self?.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                }
                return
            }
            
            let gameStatus = data["gameStatus"] as? String ?? "waiting"
            let ownerId = data["createdBy"] as? String ?? ""
            
            if gameStatus == "waiting" {
                // Before game starts
                if ownerId == self.myPlayerId {
                    // Owner leaving - REMOVE SELF, clear others
                    players.removeAll()  // Clear everyone including owner
                    
                    roomRef.updateData(["players": players]) { _ in
                        DispatchQueue.main.async {
                            self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                        }
                    }
                } else {
                    // Non-owner leaving
                    players.removeAll { $0["id"] as? String == self.myPlayerId }
                    
                    roomRef.updateData(["players": players]) { _ in
                        DispatchQueue.main.async {
                            self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                        }
                    }
                }
            } else {
                // During game
                if ownerId == self.myPlayerId {
                    // Owner leaving during game
                    players.removeAll { $0["id"] as? String == self.myPlayerId }
                    
                    if !players.isEmpty {
                        // Promote 2nd player to owner
                        let newOwnerId = players[0]["id"] as? String ?? ""
                        
                        roomRef.updateData([
                            "players": players,
                            "createdBy": newOwnerId
                        ]) { _ in
                            DispatchQueue.main.async {
                                self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                            }
                        }
                    } else {
                        // Last player - delete room
                        GameManager.shared.deleteRoom(roomId: self.roomId) { _, _ in
                            DispatchQueue.main.async {
                                self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                            }
                        }
                    }
                } else {
                    // Non-owner leaving during game
                    players.removeAll { $0["id"] as? String == self.myPlayerId }
                    
                    if players.isEmpty {
                        GameManager.shared.deleteRoom(roomId: self.roomId) { _, _ in
                            DispatchQueue.main.async {
                                self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                            }
                        }
                    } else {
                        roomRef.updateData(["players": players]) { _ in
                            DispatchQueue.main.async {
                                self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showTemporaryBanner(_ message: String) {
        // Create temporary banner
        let banner = UIView()
        banner.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 0.85)  // Reduced from 0.95
        banner.layer.cornerRadius = 12
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = message
        label.font = UIFont(name: "Helvetica-Bold", size: 15) ?? .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        banner.addSubview(label)
        
        view.addSubview(banner)
        
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            banner.heightAnchor.constraint(equalToConstant: 50),
            
            label.centerXAnchor.constraint(equalTo: banner.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: banner.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -16)
        ])
        
        // Animate in
        banner.alpha = 0
        banner.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            banner.alpha = 1
            banner.transform = .identity
        } completion: { _ in
            // Auto-dismiss after 2.5 seconds
            UIView.animate(withDuration: 0.4, delay: 2.5) {
                banner.alpha = 0
                banner.transform = CGAffineTransform(translationX: 0, y: -20)
            } completion: { _ in
                banner.removeFromSuperview()
            }
        }
    }
}
