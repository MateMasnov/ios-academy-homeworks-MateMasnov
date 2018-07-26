//
//  ShowDetails.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation

struct ShowDetails: Codable {
    
    let id: String
    let type: String
    let title: String
    let description: String
    let imageUrl: String
    let likesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case title
        case description
        case imageUrl
        case likesCount
    }
}

