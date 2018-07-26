//
//  Show.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation

struct Show: Codable {
    
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}


protocol ShowCellItemInterface {
    var title: String { get }
    var imageUrl: String { get }
}

extension Show: ShowCellItemInterface { }

