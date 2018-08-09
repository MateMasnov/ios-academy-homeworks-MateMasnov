//
//  ShowsSessionManager.swift
//  TVShows
//
//  Created by Infinum Student Academy on 07/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation
import Alamofire

class ShowsSessionManager {
    
    static var session: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    private init() {}
}

class TokenAdapter: RequestAdapter {
    
    private let _token: String
    
    init(token: String) {
        _token = token
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(_token, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
