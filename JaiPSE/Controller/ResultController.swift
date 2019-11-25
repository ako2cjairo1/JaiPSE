//
//  ResultController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/21/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation
import UIKit

class ResultController {
    
    // MARK: - Properties
    // Singleton instance
    static let shared = ResultController()
    var stockVMData = [StockViewModel]()
    var view = UIView()
    let mode: FetchMode?
    let isFilteredByUserDefaults: Bool?
    let searchKeyword: String?
    
    init() {
        self.mode = nil
        self.isFilteredByUserDefaults = nil
        self.searchKeyword = nil
    }
    
    init(requestingView: UIView, fetchMode: FetchMode, filterByUserDefaults: Bool?, searchKeyword: String? = "") {
        self.view = requestingView
        self.mode = fetchMode
        self.isFilteredByUserDefaults = filterByUserDefaults
        self.searchKeyword = searchKeyword!
    }
    
    func process(_ result: Any) -> [StockViewModel] {

        if let result = result as? Result<StockAPIModel, NetworkErrors> {
            switch result {
                case .failure(let resultError):
                    ToastMessageWidget.showMessage(toViewContainer: self.view, resultError.rawValue)
                    break
                case .success(let resultStockAPIModelData):
                    // Convert response to StockViewModel
                    stockVMData = resultStockAPIModelData.stocks.map({ return StockViewModel(stock: $0) })
            }
        } else if let result = result as? Result<StockAPIModel, FileErrors> {
            switch result {
                case .failure(let resultError):
                    ToastMessageWidget.showMessage(toViewContainer: self.view, resultError.rawValue)
                    break
                case .success(let resultStockAPIModelData):
                    // Convert response to StockViewModel
                    stockVMData = resultStockAPIModelData.stocks.map({ return StockViewModel(stock: $0) })
            }
        }
        
        // additional filter applied to array like: (1)UserDefault values and/or (2) search keyword
        return additionalFilter()
    }
    
    /// additional filter applied to array like: (1)UserDefault values and/or (2) search keyword
    fileprivate func additionalFilter() -> [StockViewModel] {
        // filter StockViewModel data using stocks added by user (stored in UserDefaults)
        if let userFilter = isFilteredByUserDefaults, userFilter  {
            if let stockCodesFromUserDefaults = UserDefaultsHelper.shared.getWatchedSymbols() {
                stockVMData = stockVMData.filter {
                    $0.createPredicate(stockCodesFromUserDefaults)
                }
            } else {
                return [StockViewModel]()
            }
        }
        
        if let keyword = self.searchKeyword, !keyword.isEmpty {
            stockVMData = stockVMData.filter({ $0.createPredicate(keyword) })
        }
        
        return stockVMData
    }
}
