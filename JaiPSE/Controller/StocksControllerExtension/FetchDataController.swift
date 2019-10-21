//
//  FetchDataController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/20/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

enum FetchMode {
    case fileResource
    case online
}

extension StocksController {
    
    internal func fetchStocks(mode: FetchMode, fromUrl urlString: String, isFilteredByUserDefaults: Bool? = true, searchKeyword: String? = "", completion: @escaping([StockViewModel]?) -> Void) {
        
        switch mode {
            case .online:
                NetworkManager.shared.fetchOnline(of: StockAPIModel.self, from: urlString) { (result) in
                    
                    DispatchQueue.main.async {
                        let controller = ResultController(requestingView: self.view, fetchMode: mode, filterByUserDefaults: isFilteredByUserDefaults, searchKeyword: searchKeyword)
                        
                        completion(controller.process(result))
                    }
                }
                break
                
            case .fileResource:
                NetworkManager.shared.fetchFromFile(of: StockAPIModel.self, fromFile: urlString) { (result) in
                    
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            let resultController = ResultController(requestingView: self.view, fetchMode: mode, filterByUserDefaults: isFilteredByUserDefaults, searchKeyword: searchKeyword)
                            
                            completion(resultController.process(result))
                        }
                    }
                }
                break
        }
    }
}
