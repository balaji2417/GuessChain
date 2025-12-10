//
//  GameManager.swift
//  WA_UI
//
//  Created by Swetha Shankara Raman on 12/7/25.
//


//
//  GameManager.swift
//  GuessChain
//
//  Added: Auto-timeout monitoring
//

import Foundation
import FirebaseFirestore

class GameManager {
    
    static let shared = GameManager()
    private let db = Firestore.firestore()
    private var timeoutTimers: [String: Timer] = [:]  // Track timeouts per room
    
    private init() {}
    
    func startGame(roomId: String, completion: @escaping (Bool, String?) -> Void) {
        let roomRef = db.collection("lobby").document(roomId)
        
        roomRef.getDocument { snapshot, error in
            if let error = error {
                completion(false, "Error fetching room: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(false, "Room not found")
                return
            }
            
            if data["questionIds"] != nil {
                completion(false, "Game already started")
                return
            }
            
            var cleanedPlayers: [[String: Any]] = []
            if let playersData = data["players"] as? [[String: Any]] {
                for player in playersData {
                    let id = player["id"] as? String ?? ""
                    let name = player["name"] as? String ?? ""
                    if !id.isEmpty && !name.isEmpty {
                        cleanedPlayers.append(player)
                    }
                }
            }
            
            if cleanedPlayers.count < 2 {
                completion(false, "Need at least 2 players")
                return
            }
            
            self.fetchRandomQuestions(count: 5) { questions, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let questions = questions, questions.count == 5 else {
                    completion(false, "Could not fetch enough questions")
                    return
                }
                
                let questionIds = questions.map { $0.id }
                let firstQuestion = questions[0]
                
                roomRef.updateData([
                    "players": cleanedPlayers,
                    "gameStatus": "in_progress",
                    "questionIds": questionIds,
                    "currentQuestionIndex": 0,
                    "currentPlayerTurnIndex": 0,
                    "answeredPlayers": [],
                    "turnStartTime": FieldValue.serverTimestamp(),  // Track when turn started
                    "currentQuestion": [
                        "id": firstQuestion.id,
                        "question": firstQuestion.question,
                        "answer": firstQuestion.answer
                    ],
                    "startedAt": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        completion(false, "Error starting game: \(error.localizedDescription)")
                    } else {
                        // Start timeout monitor
                        self.monitorTimeout(roomId: roomId)
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    private func monitorTimeout(roomId: String) {
        // Monitor for 35 seconds (5 sec grace period after 30)
        timeoutTimers[roomId]?.invalidate()
        
        timeoutTimers[roomId] = Timer.scheduledTimer(withTimeInterval: 35.0, repeats: true) { [weak self] _ in
            self?.checkAndHandleTimeout(roomId: roomId)
        }
    }
    
    private func checkAndHandleTimeout(roomId: String) {
        let roomRef = db.collection("lobby").document(roomId)
        
        roomRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let turnStartTime = data["turnStartTime"] as? Timestamp else {
                return
            }
            
            let now = Date()
            let turnStart = turnStartTime.dateValue()
            let elapsed = now.timeIntervalSince(turnStart)
            
            // If turn has been going for more than 35 seconds, force skip
            if elapsed > 35 {
                print("Force timeout - auto-skipping turn")
                
                guard let currentPlayerTurnIndex = data["currentPlayerTurnIndex"] as? Int,
                      let players = data["players"] as? [[String: Any]],
                      !players.isEmpty else {
                    return
                }
                
                let playerCount = players.count
                let currentPlayerIndex = currentPlayerTurnIndex % playerCount
                let currentPlayer = players[currentPlayerIndex]
                let playerId = currentPlayer["id"] as? String ?? ""
                
                // Force move to next turn
                self.moveToNextTurn(
                    roomId: roomId,
                    questionIds: data["questionIds"] as? [String] ?? [],
                    playerId: playerId,
                    wasCorrect: false
                ) { _, _ in
                    print("Auto-skipped inactive player")
                }
            }
        }
    }
    
    func stopTimeoutMonitor(roomId: String) {
        timeoutTimers[roomId]?.invalidate()
        timeoutTimers.removeValue(forKey: roomId)
    }
    
    private func fetchRandomQuestions(count: Int, completion: @escaping ([Question]?, String?) -> Void) {
        db.collection("Questions").getDocuments { snapshot, error in
            if let error = error {
                completion(nil, "Error fetching questions: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil, "No questions found")
                return
            }
            
            var allQuestions: [Question] = []
            for doc in documents {
                let data = doc.data()
                if let questionText = data["Question"] as? String,
                   let answer = data["Answer"] as? String {
                    let question = Question(
                        id: doc.documentID,
                        question: questionText,
                        answer: answer
                    )
                    allQuestions.append(question)
                }
            }
            
            let selectedQuestions = Array(allQuestions.shuffled().prefix(count))
            
            if selectedQuestions.count >= count {
                completion(selectedQuestions, nil)
            } else {
                completion(nil, "Not enough questions in database")
            }
        }
    }
    
    func submitAnswer(
        roomId: String,
        playerId: String,
        answer: String,
        currentQuestionIndex: Int,
        currentQuestion: Question,
        completion: @escaping (Bool, Bool, String?) -> Void
    ) {
        let isCorrect = answer.lowercased().trimmingCharacters(in: .whitespaces) ==
                       currentQuestion.answer.lowercased().trimmingCharacters(in: .whitespaces)
        
        completion(true, isCorrect, nil)
    }
    
    func moveToNextTurn(
        roomId: String,
        questionIds: [String],
        playerId: String,
        wasCorrect: Bool,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let roomRef = db.collection("lobby").document(roomId)
        
        roomRef.getDocument { snapshot, error in
            if let error = error {
                completion(false, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data(),
                  let currentQuestionIndex = data["currentQuestionIndex"] as? Int,
                  let currentPlayerTurnIndex = data["currentPlayerTurnIndex"] as? Int,
                  var players = data["players"] as? [[String: Any]] else {
                completion(false, "Invalid room data")
                return
            }
            
            // Update score if correct
            if wasCorrect && !playerId.isEmpty {
                for (index, player) in players.enumerated() {
                    if let id = player["id"] as? String, id == playerId {
                        var updatedPlayer = player
                        let currentScore = player["score"] as? Int ?? 0
                        updatedPlayer["score"] = currentScore + 10
                        players[index] = updatedPlayer
                        break
                    }
                }
            }
            
            let realPlayers = players.filter { !($0["id"] as? String ?? "").isEmpty }
            let playerCount = realPlayers.count
            
            guard playerCount > 0 else {
                completion(false, "No players in room")
                return
            }
            
            // Check if only 1 player left - end game
            if playerCount == 1 {
                roomRef.updateData([
                    "gameStatus": "completed",
                    "players": players
                ]) { error in
                    completion(error == nil, error?.localizedDescription)
                }
                return
            }
            
            var answeredPlayers = data["answeredPlayers"] as? [String] ?? []
            if !playerId.isEmpty {
                answeredPlayers.append(playerId)
            }
            
            let shouldMoveToNextQuestion = wasCorrect || (answeredPlayers.count >= playerCount)
            
            if shouldMoveToNextQuestion {
                let newQuestionIndex = currentQuestionIndex + 1
                let nextPlayerIndex = (currentPlayerTurnIndex + 1) % playerCount
                
                if newQuestionIndex >= 5 {
                    roomRef.updateData([
                        "gameStatus": "completed",
                        "players": players
                    ]) { error in
                        completion(error == nil, error?.localizedDescription)
                    }
                    return
                }
                
                let nextQuestionId = questionIds[newQuestionIndex]
                self.db.collection("Questions").document(nextQuestionId).getDocument { questionSnapshot, error in
                    guard let questionData = questionSnapshot?.data(),
                          let questionText = questionData["Question"] as? String,
                          let answer = questionData["Answer"] as? String else {
                        completion(false, "Invalid question data")
                        return
                    }
                    
                    roomRef.updateData([
                        "currentQuestionIndex": newQuestionIndex,
                        "currentPlayerTurnIndex": nextPlayerIndex,
                        "answeredPlayers": [],
                        "players": players,
                        "turnStartTime": FieldValue.serverTimestamp(),  // Reset timer
                        "currentQuestion": [
                            "id": nextQuestionId,
                            "question": questionText,
                            "answer": answer
                        ]
                    ]) { error in
                        completion(error == nil, error?.localizedDescription)
                    }
                }
            } else {
                let nextPlayerIndex = (currentPlayerTurnIndex + 1) % playerCount
                
                roomRef.updateData([
                    "currentPlayerTurnIndex": nextPlayerIndex,
                    "answeredPlayers": answeredPlayers,
                    "players": players,
                    "turnStartTime": FieldValue.serverTimestamp()  // Reset timer
                ]) { error in
                    completion(error == nil, error?.localizedDescription)
                }
            }
        }
    }
    
    func deleteRoom(roomId: String, completion: @escaping (Bool, String?) -> Void) {
        stopTimeoutMonitor(roomId: roomId)
        
        db.collection("lobby").document(roomId).delete { error in
            if let error = error {
                completion(false, "Error deleting room: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }
}

struct Question {
    let id: String
    let question: String
    let answer: String
}
