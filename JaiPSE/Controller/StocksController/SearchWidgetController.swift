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
        if !searchKeyword.isEmpty, !searchKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty /*, searchKeyword.count > 2*/ {
            let filterUserDefaults = floatingButton.toggleFloatingButton ? false : true
            
            fetchStocks(isFilteredByUserDefaults: filterUserDefaults, searchKeyword: searchKeyword) {
                (result) in
                DispatchQueue.main.async {
                    if let stockVMData = result {
                        // TODO: (1) prevent reloading of collection view and (2) animate adding of cells
                        if self.floatingButton.toggleFloatingButton {
                            self.searchResultTableView.searchResultData = stockVMData
                        } else {
                            self.isUnwatchMode = true
                            self.stocksData = stockVMData
                        }
                    }
                }
                
            }
        } else if searchKeyword.isEmpty {
            if self.floatingButton.toggleFloatingButton {
                self.searchResultTableView.searchResultData = [StockViewModel]()
            } else {
                self.isUnwatchMode = false
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
            self.isUnwatchMode = false
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
