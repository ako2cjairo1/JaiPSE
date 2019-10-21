//
//  SearchResultTableViewController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/19/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

extension StocksController {
    
    internal func setupSearchResultTableView() {
        view.addSubview(searchResultTableView)
        searchResultTableView.anchorExt(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, height: view.frame.size.height - 170)
        
        searchResultViewAnimateOut()
    }
    
    internal func searchResultViewAnimateIn() {
        searchResultTableView.alpha = 0
        searchResultTableView.transform = CGAffineTransform(translationX: 0, y: view.frame.size.height - 170)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.searchResultTableView.alpha = 1
            self.searchResultTableView.transform = .identity
        })
    }
    
    internal func searchResultViewAnimateOut() {
        floatingButton.toggleAnimation()
        searchResultTableView.alpha = 1
        searchResultTableView.transform = .identity
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 15, options: .curveEaseInOut, animations: {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height - 170)
            self.searchResultTableView.alpha = 0.5
            
        }, completion: { (success) in
            if success {
                // remove the search result item(s)
                self.searchResultTableView.isHideSearchResult = true
            }
        })
    }
}
