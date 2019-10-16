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
    case invalidData = "No/Invalid data have been received from url."
    case invalidURL = "Invalid URL."
    case general = "Something went wrong."
    case parseData = "Error parsing the data to JSON type."
    case noResponse = "No Response from server."
}

class NetworkManager {
    // Singleton
    static let shared = NetworkManager()
    
    // make sure for implementors not able to recreate an instance
    init() {}
    
    /// Fetch a generic type JSON format Data from the url string provided.
    func fetchData<T:Decodable>(of type: T.Type = T.self, from urlString: String, completion: @escaping(Result<T, NetworkManagerErrors>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("\n-->DEBUG\n\n \(NetworkManagerErrors.invalidURL.rawValue) URL: \(urlString)\n\n<--END\n")
            completion(.failure(NetworkManagerErrors.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("\n-->DEBUG\n\n\(NetworkManagerErrors.general.rawValue) \(error)\n\n<--END\n")
                completion(.failure(NetworkManagerErrors.general))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("\n-->DEBUG\n\n \(NetworkManagerErrors.noResponse.rawValue)\n\n<--END\n")
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
                        print("\n-->DEBUG\n\n \(NetworkManagerErrors.parseData.rawValue) \(parseError)\n\n<--END\n")
                        completion(.failure(NetworkManagerErrors.parseData))
                    }
                } else {
                    print("\n-->DEBUG\n\n \(NetworkManagerErrors.invalidData.rawValue)\n\n<--END\n")
                    completion(.failure(NetworkManagerErrors.invalidData))
                }
            } else {
                print("\n-->DEBUG\n\n \(NetworkManagerErrors.clientServerErrorResponse.rawValue) Status Code: \(response.statusCode). URL: \(urlString)\n\n<--END\n")
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
