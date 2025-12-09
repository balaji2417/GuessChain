//
//  GameManager.swift
//  WA_UI
//
//  Created by Swetha Shankara Raman on 12/7/25.
//


import Foundation
import FirebaseFirestore

class GameManager {
    
    static let shared = GameManager()
    private let db = Firestore.firestore()
    
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
            
            if cleanedPlayers.isEmpty {
                completion(false, "No players in room")
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
                
                // Prepare question data
                let questionIds = questions.map { $0.id }
                let firstQuestion = questions[0]
                
                // Update room with game data and cleaned players
                roomRef.updateData([
                    "players": cleanedPlayers,
                    "gameStatus": "in_progress",
                    "questionIds": questionIds,
                    "currentQuestionIndex": 0,
                    "currentPlayerTurnIndex": 0,
                    "answeredPlayers": [],
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
                        completion(true, nil)
                    }
                }
            }
        }
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
                completion(nil, "Not enough questions in database (need \(count), found \(selectedQuestions.count))")
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
        let roomRef = db.collection("lobby").document(roomId)
        
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
            
            if wasCorrect {
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
            
            var answeredPlayers = data["answeredPlayers"] as? [String] ?? []
            answeredPlayers.append(playerId)
            
            let shouldMoveToNextQuestion = wasCorrect || (answeredPlayers.count >= playerCount)
            
            if shouldMoveToNextQuestion {
                // Move to next question
                let newQuestionIndex = currentQuestionIndex + 1
                let nextPlayerIndex = (currentPlayerTurnIndex + 1) % playerCount
                
                print("DEBUG: Moving to Q\(newQuestionIndex + 1), starting with player index \(nextPlayerIndex)")
                
                // Check if game over
                if newQuestionIndex >= 5 {
                    roomRef.updateData([
                        "gameStatus": "completed",
                        "players": players
                    ]) { error in
                        completion(false, error?.localizedDescription)
                        print("Game completed!")
                    }
                    return
                }
                
                // Fetch next question
                let nextQuestionId = questionIds[newQuestionIndex]
                self.db.collection("Questions").document(nextQuestionId).getDocument { questionSnapshot, error in
                    guard let questionData = questionSnapshot?.data(),
                          let questionText = questionData["Question"] as? String,
                          let answer = questionData["Answer"] as? String else {
                        completion(false, "Invalid question data")
                        return
                    }
                    
                    // Update-new question, reset answered players
                    roomRef.updateData([
                        "currentQuestionIndex": newQuestionIndex,
                        "currentPlayerTurnIndex": nextPlayerIndex,
                        "answeredPlayers": [],  // Reset for new question
                        "players": players,
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
                // Stay on same question, move to next player
                let nextPlayerIndex = (currentPlayerTurnIndex + 1) % playerCount
                
                print("DEBUG: Same question, next player index \(nextPlayerIndex)")
                
                roomRef.updateData([
                    "currentPlayerTurnIndex": nextPlayerIndex,
                    "answeredPlayers": answeredPlayers,
                    "players": players
                ]) { error in
                    completion(error == nil, error?.localizedDescription)
                }
            }
        }
    }
    
    func deleteRoom(roomId: String, completion: @escaping (Bool, String?) -> Void) {
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
