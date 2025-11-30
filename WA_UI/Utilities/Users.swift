//
//  Users.swift
//  WA_UI
//
//  Created by Balaji Sundar on 11/30/25.
//

import Foundation
import UIKit


struct Users: Codable {
    var name: String!
    var email: String!
    var avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
            case name
            case email
            case avatarURL
        }
}
