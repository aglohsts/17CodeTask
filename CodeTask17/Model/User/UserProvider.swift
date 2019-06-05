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

enum EndPoint: String {
    
    case user = "/search/users"
}

typealias UserHandler = (Result<(UserObject, String?, String?), Error>) -> Void

class UserProvider {
    
    let decoder = JSONDecoder()
    
    let session = URLSession.shared
    
    var nextPagePath: String? = nil
    
    var lastPagePath: String? = nil
    
    func getUser(searchKeyWord: String, completion: @escaping UserHandler) {
        
        var urlComponents = NSURLComponents(
            string: Bundle.CTValueForString(key: CTConstant.urlKey) + EndPoint.user.rawValue)!
        
        urlComponents.queryItems = [
            NSURLQueryItem(name: "q", value: searchKeyWord),
            NSURLQueryItem(name: "page", value: "1")
            ] as [URLQueryItem]

        guard let url = urlComponents.url else {
            
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
                        
//                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        
                        let userObject = try strongSelf.decoder.decode(UserObject.self, from: data)
                        
                        if let linkHeader = httpResponse.allHeaderFields["Link"] as? String {
                            
                            let links = linkHeader.components(separatedBy: ", ")
                            
                            var dictionary: [String: String] = [:]
                            
                            links.forEach({
                                
                                let components = $0.components(separatedBy: "; ")
                                
                                let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                                
                                dictionary[components[1]] = cleanPath
                            })
                            
                            self?.nextPagePath = dictionary["rel=\"next\""]
                            
                            self?.lastPagePath = dictionary["rel=\"last\""]
                        }
                        
                        completion(.success((userObject, self?.nextPagePath, self?.lastPagePath)))
                        
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
    
    func getMoreUser(nextPageUrl: String, completion: @escaping UserHandler) {
        
        guard let url = URL(string: nextPageUrl) else {
            
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
                        
//                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        
                        let userObject = try strongSelf.decoder.decode(UserObject.self, from: data)
                        
                        if let linkHeader = httpResponse.allHeaderFields["Link"] as? String {
                            
                            let links = linkHeader.components(separatedBy: ", ")
                            
                            var dictionary: [String: String] = [:]
                            
                            links.forEach({
                                
                                let components = $0.components(separatedBy: "; ")
                                
                                let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                                
                                dictionary[components[1]] = cleanPath
                            })
                            
                            self?.nextPagePath = dictionary["rel=\"next\""]
                            
                            self?.lastPagePath = dictionary["rel=\"last\""]
                        }
                        
                        completion(.success((userObject, self?.nextPagePath, self?.lastPagePath)))
                        
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
}
