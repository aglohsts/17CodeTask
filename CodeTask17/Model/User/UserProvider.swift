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

typealias UserHandler = (Result<Data, NetworkError>) -> Void

class UserProvider {
    
    let decoder = JSONDecoder()
    
    let session = URLSession.shared
    
    func getUser(completion: @escaping UserHandler) {
        
        let endPoint = ""
        
        let urlString = Bundle.CTValueForString(key: CTConstant.urlKey)
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(.badURL))
            
            return
        }
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in

            if let data = data {

                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                    
                case 200 ..< 300: completion(.success(data))
                    
                case 400 ..< 500: completion(.failure(.clientError(data)))
                    
                case 500 ..< 600: completion(.failure(.serverError))
                    
                default: completion(.failure(.unexpetedError))
                }
            }
        })
        
//        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
//            <#code#>
//        })
    }
}
