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
import CoreMedia

class ApiManager {
    //MARK: - Login calls -
    static func loginAPICall(parameters: [String: String]) -> Promise<LoginData> {
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.usersUrl + "/sessions",
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
    
    static func registerAPICall(parameters: [String: String]) -> Promise<User> {
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.usersUrl,
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

    //MARK: - Home calls -
    static func getShowsAPICall(token: String) -> Promise<[Show]> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.showsUrl,
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

    //MARK: - Show Details calls -
    static func getShowDetailsAPICall(token: String, showId: String) -> Promise<ShowDetails> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.showsUrl + "/\(showId)",
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
    
    static func getAllEpisodesAPICall(token: String, showId: String) -> Promise<[Episode]> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.showsUrl + "/\(showId)/episodes",
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

    //MARK: - Episode calls -
    static func addEpisodeAPICall(parameters: [String: String], headers: [String: String]) -> Promise<Episode> {
        
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.episodesUrl,
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
    
    static func getEpisodeDetailsAPICall(episodeId: String, token: String) -> Promise<Episode> {
        let headers = ["Authorization": token]

        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.episodesUrl + "/\(episodeId)",
                         method: .get,
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
    
    //MARK: - Comments calls -
    static func getAllComments(episodeId: String, token: String) -> Promise<[Comments]> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.episodesUrl + "/\(episodeId)" + Constants.URL.baseCommentsUrl,
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data") { (response:
                    DataResponse<[Comments]>) in
                    
                    switch response.result {
                    case .success(let comments):
                        seal.fulfill(comments)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    static func addComment(parameters: [String: String], token: String) -> Promise<Comments> {
        let headers = ["Authorization": token]

        return Promise {
            seal in
            
            Alamofire
                .request(Constants.URL.baseApiUrl + Constants.URL.baseCommentsUrl,
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data") { (response:
                    DataResponse<Comments>) in
                    
                    switch response.result {
                    case .success(let comments):
                        seal.fulfill(comments)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    static func deleteComment(commentId: String, token: String) -> Promise<Void> {
        let headers = ["Authorization": token]
        
        return Promise {
            seal in
            
            Alamofire
                .request(
                    Constants.URL.baseApiUrl + Constants.URL.baseCommentsUrl + "/\(commentId)",
                    method: .delete,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .response(completionHandler: { (response) in
                    guard
                        let status: Int = response.response?.statusCode,
                        status >= 200, status <= 400
                    else {
                        guard let error = response.error else { return }
                        seal.reject(error)
                        return
                    }
                    
                    seal.fulfill(())
                    
                })
        }
    }
    
    //MARK: - Media -
//    func uploadImageOnAPI(token: String, image: UIImage, name: String) -> String? {
//        let headers = ["Authorization": token]
//        let imageByteData = UIImagePNGRepresentation(image)!
//        
//            Alamofire
//                .upload(multipartFormData: { multipartFormData in
//                    multipartFormData.append(imageByteData,
//                                             withName: "file",
//                                             fileName: name + ".png",
//                                             mimeType: "image/png")
//                }, to: Constants.URL.mediaUrl,
//                   method: .post,
//                   headers: headers)
//                { result in
//                    switch result {
//                    case .success(let uploadRequest, _, _):
//                        return self.processUploadRequest(uploadRequest)
//                    case .failure(let encodingError):
//                        print(encodingError)
//                    }
//                }
//            }
//    
//    
//    func processUploadRequest(_ uploadRequest: UploadRequest) -> String? {
//        //return Promise { seal in
//            uploadRequest
//                .responseDecodableObject(keyPath: "data") {
//                    (response: DataResponse<Media>) in
//                
//                switch response.result {
//                case .success(let media):
//                    //seal.fulfill(media)
//                    return media.id
//                    print("DECODED: \(media)")
//                case .failure(let error):
//                    //seal.reject(error)
//                    print("FAILURE: \(error)")
//                }
//            }
//        }
//    //}
    
}
