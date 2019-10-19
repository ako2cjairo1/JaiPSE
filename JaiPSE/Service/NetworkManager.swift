//
//  dataStore.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

enum NetworkManagerErrors: String, Error {
    case clientServerErrorResponse = "Client/Server Error."
    case invalidData = "Invalid data."
    case invalidURL = "Invalid URL."
    case general = "Something went wrong."
    case parseData = "Error parsing the data."
    case noConnection = "No Internet Connection"
    case noResponse = "No Response."
    
}

class NetworkManager {
    // Singleton
    static let shared = NetworkManager()
    
    private var logManager = LogHelper<NetworkManager>()
    
    // make sure for implementors not able to recreate an instance
    init() {}
    
    /// Fetch a generic type JSON format Data from the url string provided.
    func fetchData<T:Decodable>(of type: T.Type = T.self, from urlString: String, completion: @escaping(Result<T, NetworkManagerErrors>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            logManager.createLog("\(NetworkManagerErrors.invalidURL.rawValue)\nURL: \(urlString)")
            completion(.failure(NetworkManagerErrors.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error as NSError? {
                var errorType: NetworkManagerErrors
                
                switch error.code {
                case -1009:
                    errorType = .noConnection
                    break
                default:
                    errorType = .general
                }
                
                self.logManager.createLog("\(errorType.rawValue)\n\n\(error)")
                completion(.failure(errorType))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.logManager.createLog("\(NetworkManagerErrors.noResponse.rawValue)\n\n\(String(describing: error))")
                completion(.failure(NetworkManagerErrors.noResponse))
                return
            }
            
            // check for Success response code
            if 200...299 ~= response.statusCode {
                if let data = data {
                    do {
                        let jsonData = try JSONDecoder().decode(type, from: data)
                        completion(.success(jsonData))
                        
                    } catch let parseError {
                        self.logManager.createLog("\(NetworkManagerErrors.parseData.rawValue)\n\(parseError)")
                        completion(.failure(NetworkManagerErrors.parseData))
                    }
                } else {
                    self.logManager.createLog("\(NetworkManagerErrors.invalidData.rawValue)")
                    completion(.failure(NetworkManagerErrors.invalidData))
                }
            } else {
                self.logManager.createLog("\(NetworkManagerErrors.clientServerErrorResponse.rawValue)\nStatus Code: \(response.statusCode). URL: \(urlString)")
                completion(.failure(NetworkManagerErrors.clientServerErrorResponse))
            }
        }.resume()
    }
    
    func fetchData<T:Decodable>(fromFile file: String, to type: T.Type = T.self, completion: @escaping(T?, Error?) -> Void) {
        var data: Data?
        
        guard let bundledFile = Bundle.main.url(forResource: file, withExtension: nil) else {
            return
        }
        
        do {
            data = try Data(contentsOf: bundledFile)
        } catch {
            completion(nil, error)
        }
        
        do {
            let jsonData = try JSONDecoder().decode(type, from: data!)
            completion(jsonData, nil)
        } catch let parseError {
            completion(nil, parseError)
        }
    }
}
