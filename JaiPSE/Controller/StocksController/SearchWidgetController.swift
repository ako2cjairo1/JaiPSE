//
//  HeaderSearchBarController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/19/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SearchWidget and Delegate (Custom)
extension StocksController: SearchButtonDelegate {
    
    func searchBarTextDidChange(_ searchBar: UISearchBar, searchKeyword: String) {
        if !searchKeyword.isEmpty, searchKeyword.count > 2 {
            let filterUserDefaults = floatingButton.toggleFloatingButton ? false : true
            
            fetchStocks(isFilteredByUserDefaults: filterUserDefaults, searchKeyword: searchKeyword) {
                (result) in
                if let stockVMData = result {
                    if self.floatingButton.toggleFloatingButton {
                        self.searchResultTableView.searchResultData = stockVMData
                    } else {
                        self.stocksData = stockVMData
                    }
                }
                
            }
        } else if searchKeyword.isEmpty {
            if self.floatingButton.toggleFloatingButton {
                self.searchResultTableView.searchResultData = [StockViewModel]()
            } else {
                reloadStocks()
            }
        }
    }
    
    func searchButtonTapped() {
        
        if floatingButton.toggleFloatingButton {
            floatingButton.toggleFloatingButton = false
            searchResultAnimateOut()
            reloadStocks()
            
        } else if headerSearchBar.searchWidget.isSearchMode {
            reloadStocks()
        }
        // TODO: remove search key from searchbar
        // headerSearchBar.searchWidget.searchBar.text = nil
    }
    
    func searchBarTapped(searchKeyword: String?) {
        if let searchKeyword = searchKeyword {
            let filterUserDefaults = floatingButton.toggleFloatingButton ? false : true
            
            fetchStocks(isFilteredByUserDefaults: filterUserDefaults, searchKeyword: searchKeyword) {
                (result) in
                if let stockVMData = result {
                    if self.floatingButton.toggleFloatingButton {
                        self.searchResultTableView.searchResultData = stockVMData
                    } else {
                        self.stocksData = stockVMData
                    }
                }
                
            }
            
        }
    }
}
