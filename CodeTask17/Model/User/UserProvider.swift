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

enum SearchType {
    
    case user(Int)
}

typealias UserHandler = (Result<(UserObject, String?, String?), Error>) -> Void

class UserProvider {
    
    let decoder = JSONDecoder()
    
    let session = URLSession.shared
    
    func getUser(searchKeyWord: String, completion: @escaping UserHandler) {
        
        let endPoint = "/search/users?q=\(searchKeyWord)&page=1"
        
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
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        
                        let userObject = try strongSelf.decoder.decode(UserObject.self, from: data)
                        
                        print(userObject)
                        
                        print(userObject.totalCount)
                        
                        if let linkHeader = httpResponse.allHeaderFields["Link"] as? String {
                            
                            let links = linkHeader.components(separatedBy: ", ")
                            
                            print(links)
                            
                            var dictionary: [String: String] = [:]
                            
                            links.forEach({
                                
                                let components = $0.components(separatedBy: "; ")
                                
                                let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                                
                                dictionary[components[1]] = cleanPath
                            })
                            
//                            let prevPagePath = dictionary["rel=\"prev\""],
//                            let firstPagePath = dictionary["rel=\"first\""],
                            
//                            guard let lastPagePath = dictionary["rel=\"last\""] else { return }
//                            
//                            if let nextPagePath = dictionary["rel=\"next\""] {
//                                
//                                completion(.success((userObject, nextPagePath, lastPagePath)))
//                            } else {
//                                
//                                completion(.success((userObject, nil, lastPagePath)))
//                            }
                            
                            print(dictionary["rel=\"next\""])
                            
                            print(dictionary["rel=\"last\""])
                            
                            completion(.success((userObject, nil, nil)))
                        }
                        
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
    }
    
    func getMoreUser(completion: @escaping UserHandler) {
        

    }
}
