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
        self.symbol = stock.symbol
    }
}
