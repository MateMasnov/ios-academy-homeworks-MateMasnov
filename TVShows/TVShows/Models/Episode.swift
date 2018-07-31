//
//  Episode.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation

struct Episode: Codable {
    
    let showId: String?
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    let type: String?
    let id: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case showId
        case title
        case description
        case imageUrl
        case season
        case type
        case episodeNumber
    }
}

protocol EpisodeCellItemInterface {
    var title: String { get }
    var season: String { get }
    var episode: String { get }
}

extension Episode: EpisodeCellItemInterface {
    var episode: String {
        return episodeNumber
    }
}
