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

class ApiManager {

    static private var sessionManager: SessionManager = SessionManager.default
    
    static func initializeSession(token: String) {
        sessionManager.adapter = TokenAdapter(token: token)
    }
    
    static func deleteComment(commentId: String) -> Promise<Void> {
        
        return Promise {
            seal in
            
            sessionManager
                .request(
                    Constants.URL.baseApiUrl + Constants.URL.baseCommentsUrl + "/\(commentId)",
                    method: .delete,
                    encoding: JSONEncoding.default)
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
    
    static func makeAPICall<T: Decodable>(url: URLConvertible,
                                          method: HTTPMethod = HTTPMethod.get,
                                          parameters: [String: String] = [:]) -> Promise<T> {
        
        return Promise {
            seal in
            
            sessionManager
                .request(url,
                         method: method,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data") { (dataResponse:
                    DataResponse<T>) in
                    
                    switch dataResponse.result {
                    case .success(let response):
                        seal.fulfill(response)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    static func uploadImageOnAPI(image: UIImage, name: String) -> Promise<Media> {
        let imageByteData = UIImagePNGRepresentation(image)!
        
        return Promise {
            seal in
            
            sessionManager
                .upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageByteData,
                                             withName: "file",
                                             fileName: name + ".png",
                                             mimeType: "image/png")
                }, to: Constants.URL.mediaUrl,
                   method: .post)
                { result in
                    switch result {
                    case .success(let uploadRequest, _, _):
                        processUploadRequest(uploadRequest, seal: seal)
                    case .failure(let encodingError):
                        seal.reject(encodingError)
                    }
                }
            }
    }
    
    static func processUploadRequest(_ uploadRequest: UploadRequest, seal: Resolver<Media>) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") {
                (response: DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    seal.fulfill(media)
                case .failure(let error):
                    seal.reject(error)
                }
        }
    }
}
