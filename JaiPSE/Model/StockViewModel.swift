//
//  StockViewModel.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

struct StockViewModel {
    let name: String
    let price: Float
    let percentChange: Float
    let volume: Double
    let symbol: String
    
    init(stock: Stock) {
        self.name = stock.name
        self.price = stock.price.amount
        self.percentChange = stock.percentChange
        self.volume = stock.volume
        self.symbol = stock.code
    }
    
    func createPredicate(_ searchKey: String) -> Bool {
        // stock name criteria
        if self.name.lowercased().range(of: searchKey.lowercased()) != nil ||
            // stock code criteria
            self.symbol.lowercased().range(of: searchKey.lowercased()) != nil {
            return true
        }
        
        // stock price criteria
        if let price = Float(searchKey), price <= self.price {
            return true
        }
        
        return false
    }
    
    func createPredicate(_ symbols: [String]) -> Bool {
        for symbol in symbols {
            if self.symbol.lowercased() == symbol.lowercased() {
                return true
            }
        }
        return false
    }
}
