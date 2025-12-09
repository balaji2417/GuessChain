//
//  Player.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/6/25.
//

import Foundation

struct Player {
    var name: String
    var id: String
    var score: Int

    init(name: String, id: String, score: Int = 0) {
        self.name = name
        self.id = id
        self.score = score
    }
}

