//
//  Comments.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation

struct Comments: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    let userId: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case episodeId
        case userEmail
        case userId
        case type
    }
}

protocol CommentsCellItemInterface {
    var text: String { get }
    var userEmail: String { get }
}

extension Comments: CommentsCellItemInterface {
}
