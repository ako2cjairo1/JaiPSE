//
//  dataStore.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    // make sure for implementors not able to instantiate for inheritance
    init() {}
    
    func fetchData<T:Decodable>(fromUrl urlString: String, to type: T.Type = T.self, completion: @escaping(T?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("\(String(describing: self)): Invalid URL\n\(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error thrown by: \(String(describing: self))\nMessage: \(error.localizedDescription) \nDescription: \(error)")
                completion(nil, error)
            }
            
            guard let data = data else {
                print("\(String(describing: self)): No data have been received from url: \(urlString)")
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(type, from: data)
                
                completion(jsonData, nil)
            } catch {
                print("\(String(describing: self)): Error thrown during decoding process.\nMessage: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
}
