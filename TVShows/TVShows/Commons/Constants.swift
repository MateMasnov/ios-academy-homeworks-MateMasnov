//
//  Constants.swift
//  TVShows
//
//  Created by Infinum Student Academy on 31/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation
import KeychainAccess

enum Constants {
    
    enum URL {
        static let baseDomainUrl = "https://api.infinum.academy"
        static let baseUrl = "/api"
        static let baseCommentsUrl = "/comments"
        static let baseApiUrl = baseDomainUrl + baseUrl
        static let showsUrl = baseApiUrl + "/shows"
        static let episodesUrl = baseApiUrl + "/episodes"
        static let usersUrl = baseApiUrl + "/users"
        static let mediaUrl = baseApiUrl + "/media"
    }
    
    enum KeychainEnum {
        static let keychain = Keychain(service: "TVShows")
    }
    
    enum Color {
        static let application = UIColor(rgb: 0xFF758C)
    }
}
