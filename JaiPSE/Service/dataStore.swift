//
//  dataStore.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

class dataStore {
    static let shared = dataStore()
    
    // make sure for implementors not able to instantiate for inheritance
    init() {}
    
    func fetchData(completion: @escaping([StockViewModel], Error?) -> Void, symbol: String? = nil) {
        var responseData: [StockViewModel] = []
        
        var urlString = "http://phisix-api3.appspot.com/stocks.json"
        
        if let symbol = symbol {
            urlString = "http://phisix-api3.appspot.com/stocks/\(symbol).json"
        }
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            }
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let data = try JSONDecoder().decode(StockAPIModel.self, from: jsonData)
                
                responseData = data.stock.map { (stock) -> StockViewModel in
                    return StockViewModel(stock: stock)
                }
                
                completion(responseData, nil)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
            
        }).resume()
    }
}
