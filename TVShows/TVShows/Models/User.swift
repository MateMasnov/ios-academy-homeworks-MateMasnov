//
//  User.swift
//  TVShows
//
//  Created by Infinum Student Academy on 19/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation

//MARK: - Structures -
struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}
