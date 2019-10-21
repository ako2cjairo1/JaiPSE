//
//  dataStore.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

enum NetworkErrors: String, Error {
    case clientServerErrorResponse = "Client/Server Error."
    case invalidData = "Invalid data."
    case invalidURL = "Invalid URL."
    case general = "Something went wrong."
    case parseData = "Error parsing the data."
    case noConnection = "No Internet Connection"
    case noResponse = "No Response."
}

enum FileErrors: String, Error {
    case fileNotFound = "Resource file cannot be found."
    case invalidData = "Invalid data."
    case parseData = "Error parsing the data."
}

class NetworkManager {
    // Singleton
    static let shared = NetworkManager()
    
    private var logManager = LogHelper<NetworkManager>()
    
    // make sure for implementors not able to recreate an instance
    init() {}
    
    /// Fetch a generic JSON format Data from the url string provided.
    func fetchOnline<T:Decodable>(of type: T.Type = T.self, from urlString: String, completion: @escaping(Result<T, NetworkErrors>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            logManager.createLog("\(NetworkErrors.invalidURL.rawValue)\nURL: \(urlString)")
            completion(.failure(NetworkErrors.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error as NSError? {
                var errorType: NetworkErrors
                
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
                self.logManager.createLog("\(NetworkErrors.noResponse.rawValue)\n\n\(String(describing: error))")
                completion(.failure(NetworkErrors.noResponse))
                return
            }
            
            // check for Success response code
            if 200...299 ~= response.statusCode {
                if let data = data {
                    do {
                        let jsonData = try JSONDecoder().decode(type, from: data)
                        completion(.success(jsonData))
                        
                    } catch let parseError {
                        self.logManager.createLog("\(NetworkErrors.parseData.rawValue)\n\(parseError)")
                        completion(.failure(NetworkErrors.parseData))
                    }
                } else {
                    self.logManager.createLog("\(NetworkErrors.invalidData.rawValue)")
                    completion(.failure(NetworkErrors.invalidData))
                }
            } else {
                self.logManager.createLog("\(NetworkErrors.clientServerErrorResponse.rawValue)\nStatus Code: \(response.statusCode). URL: \(urlString)")
                completion(.failure(NetworkErrors.clientServerErrorResponse))
            }
        }.resume()
    }
    
    /// Fetch generic JSON format data from source file.
    func fetchFromFile<T:Decodable>(of type: T.Type = T.self, fromFile file: String, completion: @escaping(Result<T, FileErrors>) -> Void) {
        
        // convert bundle file path to URL string
        guard let bundledFile = Bundle.main.url(forResource: file, withExtension: nil) else {
            logManager.createLog("\(FileErrors.fileNotFound.rawValue)\nFile: \(file)")
            completion(.failure(FileErrors.fileNotFound))
            return
        }
        
        do {
            // Read the data from bundle file
            let data: Data = try Data(contentsOf: bundledFile)
            
            do {
                // Parse/Decode data to generic type
                let jsonData = try JSONDecoder().decode(type, from: data)
                completion(.success(jsonData))
                
            } catch let parseError {
                self.logManager.createLog("\(FileErrors.parseData.rawValue)\n\(parseError)")
                completion(.failure(FileErrors.parseData))
            }
            
        } catch let dataError {
            self.logManager.createLog("\(FileErrors.invalidData.rawValue)\n\(dataError)")
            completion(.failure(FileErrors.invalidData))
        }
    }
}
