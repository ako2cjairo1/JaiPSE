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
    
    internal func fetchStocks(mode: FetchMode? = .online, isFilteredByUserDefaults: Bool? = true, searchKeyword: String? = "", completion: @escaping([StockViewModel]?) -> Void) {
        
        let controller = ResultController(requestingView: self.view,
                                          fetchMode: mode!,
                                          filterByUserDefaults: isFilteredByUserDefaults,
                                          searchKeyword: searchKeyword)
        
        switch mode! {
            case .online:
                NetworkManager.shared.fetchOnline(of: StockAPIModel.self, from: Constant.urlStocks) {
                    (result) in
                    DispatchQueue.main.async {
                        completion(controller.process(result))
                    }
                }
                break
                
            case .fileResource:
                NetworkManager.shared.fetchFromFile(of: StockAPIModel.self, fromFile: Constant.urlOfflineData) {
                    (result) in
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            completion(controller.process(result))
                        }
                    }
                }
                break
        }
    }
}
