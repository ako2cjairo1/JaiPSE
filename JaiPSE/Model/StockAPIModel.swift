//
//  StockModel.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/11/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

struct StockAPIModel: Decodable {
    var stock: [Stock]
    var as_of: String
    
//    private enum CodingKeys: String, CodingKey {
//        case asOf = "as_of"
//    }
}

struct Stock: Decodable {
    var name: String
    var price: StockPrice
    var percent_change: Float
    var volume: Double
    var symbol: String
}

struct StockPrice: Decodable {
    var currency: String
    var amount: Float
}
