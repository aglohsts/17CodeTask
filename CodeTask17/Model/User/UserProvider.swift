//
//  UserProvider.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    
    case badURL
    
    case decodedDataFail
    
    case clientError(Data)
    
    case serverError
    
    case unexpetedError
}

typealias UserHandler = (Result<UserObject, Error>) -> Void

class UserProvider {
    
    let decoder = JSONDecoder()
    
    let session = URLSession.shared
    
    func getUser(completion: @escaping UserHandler) {
        
        let endPoint = "/search/users?q=tom"
        
        let urlString = Bundle.CTValueForString(key: CTConstant.urlKey) + endPoint
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(NetworkError.badURL))
            
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            
            guard let strongSelf = self else { return }

            if let data = data {

                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                    
                case 200 ..< 300:
                    
                    do {
                        
                        let userObject = try strongSelf.decoder.decode(UserObject.self, from: data)
                        
                        completion(.success(userObject))
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                case 400 ..< 500: completion(.failure(NetworkError.clientError(data)))
                    
                case 500 ..< 600: completion(.failure(NetworkError.serverError))
                    
                default: completion(.failure(NetworkError.unexpetedError))
                }
            }
            
        })
        
        task.resume()
        
//        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
//            <#code#>
//        })
    }
}
