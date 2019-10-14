//
//  StockModel.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/11/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

struct StockModel {
    var stocks: [Stock]
    var as_of: String
}

struct Stock {
    var name: String
    var price: StockPrice
    var percentChange: Float
    var volume: Double
    var symbol: String
}

struct StockPrice {
    var currency: String
    var amount: Double
}
