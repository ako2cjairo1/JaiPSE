//
//  dataStore.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

class NetworkManager {
    // MARK: - Properties
    static let shared = NetworkManager()
    private let logManager = LogHelper<NetworkManager>()
    
    // MARK: - Init
    // make sure for implementors not able to recreate an instance
    init() {}
    
    // MARK: - Functions
    /// Fetch a generic JSON format Data from the url string provided.
    internal func fetchOnline<T:Decodable>(of type: T.Type = T.self, from urlString: String, completion: @escaping(Result<T, NetworkErrors>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            Log("\(NetworkErrors.invalidURL.rawValue)\nURL: \(urlString)")
            completion(.failure(NetworkErrors.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if let error = error as NSError? {
                let errorType: NetworkErrors
                
                switch error.code {
                case -1009:
                    errorType = .noConnection
                    break
                default:
                    errorType = .general
                }
                
                self.Log("\(errorType.rawValue)\n\n\(error)")
                completion(.failure(errorType))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.Log("\(NetworkErrors.noResponse.rawValue)\n\n\(String(describing: error))")
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
                        self.Log("\(NetworkErrors.parseData.rawValue)\n\(parseError)")
                        completion(.failure(NetworkErrors.parseData))
                    }
                } else {
                    self.Log("\(NetworkErrors.invalidData.rawValue)")
                    completion(.failure(NetworkErrors.invalidData))
                }
            } else {
                self.Log("\(NetworkErrors.clientServerErrorResponse.rawValue)\nStatus Code: \(response.statusCode). URL: \(urlString)")
                completion(.failure(NetworkErrors.clientServerErrorResponse))
            }
        }.resume()
    }
    
    /// Fetch generic JSON format data from source file.
    internal func fetchFromFile<T:Decodable>(of type: T.Type = T.self, fromFile file: String, completion: @escaping(Result<T, FileErrors>) -> Void) {
        
        // convert bundle file path to URL string
        guard let bundledFile = Bundle.main.url(forResource: file, withExtension: nil) else {
            Log("\(FileErrors.fileNotFound.rawValue)\nFile: \(file)")
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
                self.Log("\(FileErrors.parseData.rawValue)\n\(parseError)")
                completion(.failure(FileErrors.parseData))
            }
            
        } catch let dataError {
            self.Log("\(FileErrors.invalidData.rawValue)\n\(dataError)")
            completion(.failure(FileErrors.invalidData))
        }
    }
}

// MARK: - Extensions
extension NetworkManager: LogHelperDelegate {
    internal func Log(_ logMessage: String, _ severity: Severity? = .error) {
        logManager.createLog(logMessage, severity)
    }
}
