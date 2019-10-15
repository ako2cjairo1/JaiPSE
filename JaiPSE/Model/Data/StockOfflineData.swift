//
//  StockOfflineData.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/14/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

class StockOfflineData {
    static let stocks: [Stock] = [
        Stock(name: "Jollibee", price: StockPrice(currency: "PHP", amount: 234.60), percentChange: 1.47, volume: 68120, symbol: "JFC"),
        Stock(name: "Asiabest Gorup", price: StockPrice(currency: "PHP", amount: 0.85), percentChange: -1.16, volume: 328000, symbol: "ABA"),
        Stock(name: "PUREGOLD", price: StockPrice(currency: "PHP", amount: 5.14), percentChange: 0.20, volume: 15600, symbol: "PGOLD")
    ]
}
