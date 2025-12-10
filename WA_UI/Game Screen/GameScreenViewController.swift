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
    
    private var listener: ListenerRegistration?
    private var isProcessingTurn: Bool = false
    
    private var currentPlayers: [Player] = []
    private var currentQuestionIds: [String] = []
    private var currentQuestion: Question?
    private var currentQuestionIndex: Int = 0
    private var currentPlayerTurnIndex: Int = 0
    private var gameStatus: String = "waiting"
    
    override func loadView() {
        gameView = GameScreenView()
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Game Room"
        navigationItem.hidesBackButton = true
        
        let leaveBtn = UIBarButtonItem(title: "Leave", style: .plain, target: self,
                                       action: #selector(leaveGame))
        leaveBtn.tintColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        navigationItem.rightBarButtonItem = leaveBtn
        
        gameView.submitBtn.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        gameView.startGameBtn.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        // Request notification permission
        LocalNotificationManager.shared.requestPermission()
        
        // Observe app lifecycle for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        becomeFirstResponder()
        setupRoomListener()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - App Lifecycle for Local Notifications
    @objc func appDidEnterBackground() {
        // Only send notification if game is in progress
        if gameStatus == "in_progress" {
            LocalNotificationManager.shared.scheduleGameOnHoldNotification()
        }
    }
    
    @objc func appWillEnterForeground() {
        // Cancel notification when user returns
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
    
    func handleShakeGesture() {
        guard gameStatus == "in_progress" else { return }
        
        guard currentPlayers.count > 0 else { return }
        
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        guard currentPlayerIndex == myPlayerIndex else {
            print("Not your turn, can't skip")
            return
        }
        
        guard !isProcessingTurn else {
            print("Already processing, can't skip")
            return
        }
        
        let alert = UIAlertController(
            title: "Skip Question?",
            message: "Shake detected! Skip this question?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Skip", style: .destructive) { [weak self] _ in
            self?.skipQuestion()
        })
        
        present(alert, animated: true)
    }
    
    func skipQuestion() {
        guard let question = currentQuestion else { return }
        
        isProcessingTurn = true
        disableInput()
        
        GameManager.shared.submitAnswer(
            roomId: roomId,
            playerId: myPlayerId,
            answer: "Skipped",
            currentQuestionIndex: currentQuestionIndex,
            currentQuestion: question
        ) { [weak self] success, isCorrect, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.isProcessingTurn = false
                    self.showAlert(message: error)
                    return
                }
                
                self.gameView.showAnswerAnimation(answer: "Skipped", isCorrect: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    GameManager.shared.moveToNextTurn(
                        roomId: self.roomId,
                        questionIds: self.currentQuestionIds,
                        playerId: self.myPlayerId,
                        wasCorrect: false
                    ) { success, error in
                        if let error = error {
                            print("Error moving to next turn: \(error)")
                            DispatchQueue.main.async {
                                self.isProcessingTurn = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
        
        // If there are any pendinging notification->cancelling out
        
        LocalNotificationManager.shared.cancelGameNotification()
    }
        
    func setupRoomListener() {
        let db = Firestore.firestore()
        
        listener = db.collection("lobby").document(roomId).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error listening to room: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Room deleted or not found")
                DispatchQueue.main.async {
                    self.showAlert(message: "Room no longer exists") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                return
            }
            
            self.handleRoomUpdate(data: data)
        }
    }
    
    func handleRoomUpdate(data: [String: Any]) {
        if let playersData = data["players"] as? [[String: Any]] {
            currentPlayers = []
            var tempMyPlayerIndex = -1
            
            for playerData in playersData {
                let id = playerData["id"] as? String ?? ""
                let name = playerData["name"] as? String ?? ""
                let score = playerData["score"] as? Int ?? 0
                
                if !id.isEmpty && !name.isEmpty {
                    let player = Player(name: name, id: id, score: score)
                    currentPlayers.append(player)
                    
                    if id == myPlayerId {
                        tempMyPlayerIndex = currentPlayers.count - 1
                    }
                }
            }
            
            myPlayerIndex = tempMyPlayerIndex
            print("DEBUG: Loaded \(currentPlayers.count) real players, myPlayerIndex=\(myPlayerIndex), myPlayerId=\(myPlayerId)")
            
            updatePlayerCards()
        }
        
        let newGameStatus = data["gameStatus"] as? String ?? "waiting"
        let statusChanged = newGameStatus != gameStatus
        gameStatus = newGameStatus
        
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
        
        switch gameStatus {
        case "waiting":
            gameView.showStartOverlay()
            gameView.questionLabel.text = "Waiting for game to start..."
            gameView.roundLabel.text = "Get ready!"
            disableInput()
            
        case "in_progress":
            gameView.startGameBtn.isHidden = true
            updateGameUI()
            
            if turnChanged || statusChanged || questionChanged {
                isProcessingTurn = false
                checkTurn()
            }
            
        case "completed":
            gameView.startGameBtn.isHidden = true
            disableInput()
            gameView.hideTurnIndicator()
            navigateToLeaderboard()
            
        default:
            break
        }
    }
    
    func updatePlayerCards() {
        let allCards = [gameView.playerCard1, gameView.playerCard2, gameView.playerCard3, gameView.playerCard4]
        let allNameLabels = [gameView.playerName1, gameView.playerName2, gameView.playerName3, gameView.playerName4]
        let allScoreLabels = [gameView.playerScore1, gameView.playerScore2, gameView.playerScore3, gameView.playerScore4]
        
        allCards.forEach { $0?.isHidden = true }
        
        for (index, player) in currentPlayers.enumerated() {
            if index < 4 {
                allCards[index]?.isHidden = false
                let displayName = (index == myPlayerIndex) ? "YOU" : player.name
                allNameLabels[index]?.text = displayName
                allScoreLabels[index]?.text = "\(player.score)"
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
        if isProcessingTurn {
            print("DEBUG: Already processing turn, skipping")
            return
        }
        
        guard currentPlayers.count > 0 else {
            print("DEBUG: No players!")
            return
        }
        
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        print("DEBUG: checkTurn - totalTurn=\(currentPlayerTurnIndex), playerCount=\(currentPlayers.count), currentPlayerIndex=\(currentPlayerIndex), myIndex=\(myPlayerIndex)")
        
        if currentPlayerIndex == myPlayerIndex {
            print("DEBUG: It's MY turn!")
            isProcessingTurn = false
            enableInput()
            gameView.showTurnIndicator("YOUR TURN")
        } else {
            let otherPlayer = currentPlayers[currentPlayerIndex]
            let displayName = otherPlayer.name
            gameView.showTurnIndicator("\(displayName)'s Turn")
            disableInput()
            isProcessingTurn = true
            
            // Simulate other player's answer after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let self = self, self.isProcessingTurn else { return }
                self.simulatePlayerAnswer()
            }
        }
    }
    
    func enableInput() {
        print("DEBUG: enableInput() called")
        DispatchQueue.main.async {
            self.gameView.answerField.isEnabled = true
            self.gameView.answerField.text = ""
            self.gameView.answerField.placeholder = "Type your answer here"
            self.gameView.answerField.backgroundColor = .white
            self.gameView.submitBtn.isEnabled = true
            self.gameView.submitBtn.alpha = 1.0
            self.gameView.answerField.becomeFirstResponder()
            self.gameView.showShakeHint()
            print("DEBUG: Input enabled, field isEnabled=\(self.gameView.answerField.isEnabled)")
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
    
    @objc func startGame() {
        gameView.startGameBtn.isEnabled = false
        
        gameView.hideStartOverlay {
            print("Game revealed!")
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
        
        guard let question = currentQuestion else { return }
        
        isProcessingTurn = true
        disableInput()
        
        GameManager.shared.submitAnswer(
            roomId: roomId,
            playerId: myPlayerId,
            answer: answerText,
            currentQuestionIndex: currentQuestionIndex,
            currentQuestion: question
        ) { [weak self] success, isCorrect, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.isProcessingTurn = false
                    self.showAlert(message: error)
                    return
                }
                
                self.gameView.showAnswerAnimation(answer: answerText, isCorrect: isCorrect)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    GameManager.shared.moveToNextTurn(
                        roomId: self.roomId,
                        questionIds: self.currentQuestionIds,
                        playerId: self.myPlayerId,
                        wasCorrect: isCorrect
                    ) { success, error in
                        if let error = error {
                            print("Error moving to next turn: \(error)")
                            DispatchQueue.main.async {
                                self.isProcessingTurn = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func simulatePlayerAnswer() {
        guard let question = currentQuestion else {
            isProcessingTurn = false
            return
        }
        
        guard currentPlayers.count > 0 else {
            isProcessingTurn = false
            return
        }
        
        let currentPlayerIndex = currentPlayerTurnIndex % currentPlayers.count
        let otherPlayer = currentPlayers[currentPlayerIndex]
        
        // Generate random answer (30% chance of correct for simulation)
        let shouldBeCorrect = Int.random(in: 0...2) == 0
        
        let answer: String
        if shouldBeCorrect {
            answer = question.answer
        } else {
            let wrongAnswers = [
                "Batman", "Superman", "Spider-Man", "Iron Man",
                "Diana Prince", "Bruce Wayne", "Clark Kent",
                "New York", "Gotham", "Metropolis", "London",
                "1995", "2005", "2010", "2020",
                "Jennifer", "Michael", "Sarah", "David",
                "Blue", "Red", "Green", "Yellow",
                "Dog", "Cat", "Lion", "Eagle",
                "Pizza", "Burger", "Pasta", "Sushi",
                "USA", "UK", "France", "Japan",
                "Monday", "Tuesday", "Friday", "Saturday"
            ]
            answer = wrongAnswers.randomElement() ?? "I don't know"
        }
        
        GameManager.shared.submitAnswer(
            roomId: roomId,
            playerId: otherPlayer.id,
            answer: answer,
            currentQuestionIndex: currentQuestionIndex,
            currentQuestion: question
        ) { [weak self] success, isCorrect, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Simulated player answer error: \(error)")
                    self.isProcessingTurn = false
                    return
                }
                
                self.gameView.showAnswerAnimation(answer: answer, isCorrect: isCorrect)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    GameManager.shared.moveToNextTurn(
                        roomId: self.roomId,
                        questionIds: self.currentQuestionIds,
                        playerId: otherPlayer.id,
                        wasCorrect: isCorrect
                    ) { success, error in
                        if let error = error {
                            print("Error moving to next turn: \(error)")
                            DispatchQueue.main.async {
                                self.isProcessingTurn = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func navigateToLeaderboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            let leaderboardVC = LeaderboardViewController()
            leaderboardVC.roomId = self.roomId
            leaderboardVC.players = self.currentPlayers
            leaderboardVC.myPlayerId = self.myPlayerId
            self.navigationController?.pushViewController(leaderboardVC, animated: true)
        }
    }
        
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    @objc func leaveGame() {
        let alert = UIAlertController(title: "Leave Game?", message: "Are you sure you want to leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Remove listener first
            self.listener?.remove()
            
            // Cancel any pending notifications
            LocalNotificationManager.shared.cancelGameNotification()
            
            // Delete room and go back
            GameManager.shared.deleteRoom(roomId: self.roomId) { success, error in
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers([LobbyViewController()], animated: true)
                }
            }
        })
        present(alert, animated: true)
    }
}
