//
//  Media.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation

struct Media: Codable {
    let id: String
    let path: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case path
        case type
    }
}
