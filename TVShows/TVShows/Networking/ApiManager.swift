//
//  ApiManager.swift
//  TVShows
//
//  Created by Infinum Student Academy on 31/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation
import CodableAlamofire
import Alamofire
import PromiseKit

protocol ApiManager {
}

extension ApiManager where Self: LoginViewController {
    func loginAPICall(parameters: [String: String]) -> Promise<LoginData> {
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/users/sessions",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<LoginData>) in
                    
                    switch response.result {
                    case .success(let loginDataResult):
                        seal.fulfill(loginDataResult)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    func registerAPICall(parameters: [String: String]) -> Promise<User> {
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<User>) in
                    
                    switch response.result {
                    case .success(let userResult):
                        seal.fulfill(userResult)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}

extension ApiManager where Self: HomeViewController {
    func getShowsAPICall(token: String) -> Promise<[Show]> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/shows",
                         method: .get,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<[Show]>) in
                    
                    switch response.result {
                    case .success(let responseArray):
                        seal.fulfill(responseArray)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}

extension ApiManager where Self: ShowDetailsViewController {
    func getShowDetailsAPICall(token: String, showId: String) -> Promise<ShowDetails> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(showId)",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<ShowDetails>) in
                    
                    switch response.result {
                    case .success(let detailsResponse):
                        seal.fulfill(detailsResponse)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    func getAllEpisodesAPICall(token: String, showId: String) -> Promise<[Episode]> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(showId)/episodes",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<[Episode]>) in
                    
                    switch response.result {
                    case .success(let episodes):
                        seal.fulfill(episodes)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}

extension ApiManager where Self: AddEpisodeViewController {
    func addEpisodeAPICall(parameters: [String: String], headers: [String: String]) -> Promise<Episode> {
        
        return Promise {
            seal in
            
            Alamofire
                .request("https://api.infinum.academy/api/episodes",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data") { (response:
                    DataResponse<Episode>) in
                    
                    switch response.result {
                    case .success(let episode):
                        seal.fulfill(episode)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}
