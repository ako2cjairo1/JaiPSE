//
//  StockModel.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/11/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

struct StockAPIModel: Codable {
    let stock: [Stock]
    let asOf: String

    private enum CodingKeys: String, CodingKey {
        case stock
        case asOf = "as_of"
    }
}

struct Stock: Codable {
    let name: String
    let price: StockPrice
    let percentChange: Float
    let volume: Double
    let symbol: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case price
        case percentChange = "percent_change"
        case volume
        case symbol
    }
}

struct StockPrice: Codable {
    let currency: String
    let amount: Float
}
