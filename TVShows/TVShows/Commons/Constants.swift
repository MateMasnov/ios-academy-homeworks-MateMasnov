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
        static let baseDomainUrl: String = "https://api.infinum.academy"
        static let baseUrl: String = "/api"
        static let baseApiUrl: String = baseDomainUrl + baseUrl
        static let showsUrl: String = baseApiUrl + "/shows"
        static let episodesUrl: String = baseApiUrl + "/episodes"
        static let usersUrl: String = baseApiUrl + "/users"
    }
    
    enum KeychainEnum {
        static let keychain = Keychain(service: "TVShows")
    }
}
