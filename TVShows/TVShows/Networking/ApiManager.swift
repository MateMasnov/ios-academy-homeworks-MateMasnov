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
    
    static func makeAPICall<T: Decodable>(url: URLConvertible,
                                          method: HTTPMethod = HTTPMethod.get,
                                          headers: [String: String] = [:],
                                          parameters: [String: String] = [:]) -> Promise<T> {
        
        return Promise {
            seal in
            
            Alamofire
                .request(url,
                         method: method,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: headers)
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
    
    static func uploadImageOnAPI(token: String, image: UIImage, name: String) -> Promise<Media>
    {
        let headers = ["Authorization": token]
        let imageByteData = UIImagePNGRepresentation(image)!
        
        return Promise {
            seal in
            
            Alamofire
                .upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageByteData,
                                             withName: "file",
                                             fileName: name + ".png",
                                             mimeType: "image/png")
                }, to: Constants.URL.mediaUrl,
                   method: .post,
                   headers: headers)
                { result in
                    switch result {
                    case .success(let uploadRequest, _, _):
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
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
            }
    }
}
