//
//  GameScreenViewController.swift
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
    private var previousPlayerIds: Set<String> = []
    private var hasShownHostLeftAlert: Bool = false
    private var ownerWasEverPresent: Bool = false
    
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
        NetworkManager.shared.observe(from: self)
        title = "Game Room"
        navigationItem.hidesBackButton = true
        
        let leaveBtn = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(leaveGame))
        leaveBtn.tintColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        navigationItem.rightBarButtonItem = leaveBtn
        
        gameView.submitBtn.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        gameView.startGameBtn.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        // Add observers for app background/foreground notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        becomeFirstResponder()
        setupRoomListener()
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Cancel notification when returning to game screen
        LocalNotificationManager.shared.cancelGameNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        
        // Schedule notification if leaving while game is in progress
        if gameStatus == "in_progress" {
            LocalNotificationManager.shared.scheduleGameOnHoldNotification()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        listener?.remove()
    }
    
    // MARK: - App Lifecycle Notifications
    
    @objc func appDidEnterBackground() {
        // Schedule notification when app goes to background during active game
        if gameStatus == "in_progress" {
            LocalNotificationManager.shared.scheduleGameOnHoldNotification()
        }
    }
    
    @objc func appWillEnterForeground() {
        // Cancel notification when returning to app
        LocalNotificationManager.shared.cancelGameNotification()
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
                let nsError = error as NSError
                
                // Ignore network-related Firebase errors (handled by NetworkManager)
                // FirestoreErrorCode.unavailable = 14 (network issues)
                // FirestoreErrorCode.cancelled = 1 (request cancelled)
                if nsError.domain == "FIRFirestoreErrorDomain" {
                    let errorCode = nsError.code
                    if errorCode == 14 || errorCode == 1 {
                        print("Firebase network error (handled by NetworkManager): \(error.localizedDescription)")
                        return
                    }
                }
                
                // Also ignore if no network connection
                if !NetworkManager.shared.isConnected {
                    print("Firebase error during network outage (ignored): \(error.localizedDescription)")
                    return
                }
                
                print("Error listening to room: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Room deleted")
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
        
        // Check if owner is in the room
        let ownerInRoom = currentPlayers.contains { $0.id == roomOwnerId }
        
        // Track if owner was EVER present
        if ownerInRoom {
            ownerWasEverPresent = true
        }
        
        // Check if owner LEFT (only if they were present before and now they're not)
        if gameStatus == "waiting" && !isOwner && !hasShownHostLeftAlert {
            let hostActuallyLeft = ownerWasEverPresent && !ownerInRoom && !roomOwnerId.isEmpty
            
            if hostActuallyLeft {
                hasShownHostLeftAlert = true
                
                gameView.startOverlay.isHidden = true
                gameView.showWaitingForHost()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showAlert(message: "Host has left the room") {
                        self.listener?.remove()
                        
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
            timer?.invalidate()
            gameView.hideTimer()
            
            let db = Firestore.firestore()
            db.collection("lobby").document(self.roomId).updateData([
                "gameStatus": "completed"
            ]) { _ in }
            return
        }
        
        // Detect if someone left during game
        if gameStatus == "in_progress" && previousPlayerCount > 0 {
            let playersWhoLeft = previousPlayerIds.subtracting(newPlayerIds)
            
            if !playersWhoLeft.isEmpty {
                showTemporaryBanner("Player left the game")
                
                if currentPlayers.count > 0 {
                    let currentPlayerIndex = currentPlayerTurnIndex % max(previousPlayerCount, 1)
                    var needsSkip = false
                    
                    if currentPlayerIndex < currentPlayers.count {
                        // Player is still there
                    } else {
                        needsSkip = true
                    }
                    
                    for _ in playersWhoLeft {
                        needsSkip = true
                        break
                    }
                    
                    if needsSkip {
                        print("Player whose turn it was left - skipping NOW")
                        timer?.invalidate()
                        gameView.hideTimer()
                        
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
    
    // MARK: - UI Updates
    
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
    
    func checkTurn() {
        guard currentPlayers.count > 0 else { return }
        
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        let currentPlayer = currentPlayers[currentPlayerIndex]
        
        startTimer()
        
        if currentPlayerIndex == myPlayerIndex {
            enableInput()
            gameView.showTurnIndicator("YOUR TURN")
        } else {
            gameView.showTurnIndicator("\(currentPlayer.name)'s Turn")
            disableInput()
        }
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
    
    // MARK: - Timer
    
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
            disableInput()
            submitAnswerToFirestore("Timeout")
        }
    }
    
    // MARK: - Game Actions
    
    @objc func startGame() {
        guard currentPlayers.count >= 2 else {
            showAlert(message: "Need at least 2 players to start")
            return
        }
        
        guard isOwner else {
            showAlert(message: "Only the host can start the game")
            return
        }
        
        // Check network before starting
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        
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
        
        // Check network before submitting
        guard NetworkManager.shared.checkAndAlert(on: self) else { return }
        
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
    
    // MARK: - Navigation
    
    func navigateToLeaderboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.listener?.remove()
            
            let leaderboardVC = LeaderboardViewController()
            leaderboardVC.roomId = self.roomId
            leaderboardVC.players = self.currentPlayers
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
        
        // Cancel any pending notifications when explicitly leaving
        LocalNotificationManager.shared.cancelGameNotification()
        
        let db = Firestore.firestore()
        let roomRef = db.collection("lobby").document(roomId)
        
        roomRef.getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  var players = data["players"] as? [[String: Any]] else {
                DispatchQueue.main.async {
                    self?.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                }
                return
            }
            
            let gameStatus = data["gameStatus"] as? String ?? "waiting"
            let ownerId = data["createdBy"] as? String ?? ""
            
            if gameStatus == "waiting" {
                if ownerId == self.myPlayerId {
                    players.removeAll()
                    
                    roomRef.updateData(["players": players]) { _ in
                        DispatchQueue.main.async {
                            self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                        }
                    }
                } else {
                    players.removeAll { $0["id"] as? String == self.myPlayerId }
                    
                    roomRef.updateData(["players": players]) { _ in
                        DispatchQueue.main.async {
                            self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                        }
                    }
                }
            } else {
                if ownerId == self.myPlayerId {
                    players.removeAll { $0["id"] as? String == self.myPlayerId }
                    
                    if !players.isEmpty {
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
                        GameManager.shared.deleteRoom(roomId: self.roomId) { _, _ in
                            DispatchQueue.main.async {
                                self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                            }
                        }
                    }
                } else {
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
    
    // MARK: - Alerts & Banners
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        // Don't show error alerts if it's a network issue (NetworkManager handles it)
        if !NetworkManager.shared.isConnected {
            let lowercased = message.lowercased()
            if lowercased.contains("error") || lowercased.contains("failed") || lowercased.contains("network") {
                print("Suppressed alert during network outage: \(message)")
                return
            }
        }
        
        // Don't show if already presenting something
        if self.presentedViewController != nil {
            print("Alert suppressed (already presenting): \(message)")
            return
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showTemporaryBanner(_ message: String) {
        let banner = UIView()
        banner.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 0.85)
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
        
        banner.alpha = 0
        banner.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            banner.alpha = 1
            banner.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 2.5) {
                banner.alpha = 0
                banner.transform = CGAffineTransform(translationX: 0, y: -20)
            } completion: { _ in
                banner.removeFromSuperview()
            }
        }
    }
}
