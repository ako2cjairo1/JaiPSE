//
//  StockViewModel.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

struct StockViewModel {
    var name: String
    var price: Float
    var percentChange: Float
    var volume: Double
    var symbol: String
    
    init(stock: Stock) {
        self.name = stock.name
        self.price = stock.price.amount
        self.percentChange = stock.percentChange
        self.volume = stock.volume
        self.symbol = stock.code
    }
    
    func createPredicate(_ searchKey: String, _ stock: StockViewModel) -> Bool {
        if stock.name.lowercased().range(of: searchKey.lowercased()) != nil {
            return true
        }
        
        if stock.symbol.lowercased().range(of: searchKey.lowercased()) != nil {
            return true
        }
        
        if let price = Float(searchKey), price <= stock.price {
            return true
        }
        
        return false
    }
    
    func createPredicate(_ symbols: [String], _ stock: StockViewModel) -> Bool {
        for symbol in symbols {
            if stock.symbol.lowercased().range(of: symbol.lowercased()) != nil {
                return true
            }
        }
        
        return false
    }
}
