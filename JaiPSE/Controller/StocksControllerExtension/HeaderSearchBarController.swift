//
//  HeaderSearchBarController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/19/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

// MARK: - SearchWidget and Delegate (Custom)
extension StocksController: SearchButtonDelegate {
    
    func searchButtonTapped() {
        
        if floatingButton.toggleFloatingButton {
            floatingButton.toggleFloatingButton = false
            
            searchResultViewAnimateOut()
            
        } else {
            if headerSearchBar.searchWidget.isSearchMode {
                fetchStocks(mode: .online, fromUrl: Constant.urlStocks, isFilteredByUserDefaults: true) { (result) in
                    if let stockVMData = result {
                        self.stocksData = stockVMData
                    }
                }
            }
        }
        // TODO: remove search key from searchbar
        // headerSearchBar.searchWidget.searchBar.text = nil
    }
    
    func searchBarTapped(searchKeyword: String?) {
        if let searchKeyword = searchKeyword {
            let filterUserDefaults = floatingButton.toggleFloatingButton ? false : true
            
            fetchStocks(mode: .online, fromUrl: Constant.urlStocks, isFilteredByUserDefaults: filterUserDefaults, searchKeyword: searchKeyword) { (result) in
                
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
