//
//  FloatingButtonController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/19/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Floating button controller functions 
extension StocksController {
    
    internal func setupFloatingButton() {
        floatingButton.delegate = self
        
        let buttonHeight: CGFloat = 50
        let bottomPadding: CGFloat = (view.safeAreaInsets.bottom + buttonHeight)
        
        view.addSubview(floatingButton)
        floatingButton.anchorExt(bottom: view.bottomAnchor, paddingBottom: bottomPadding,
                                       trailing: view.trailingAnchor, paddingTrail: 30,
                                       width: 50, height: buttonHeight)
    }
    
    fileprivate func toggleActionWithAnimation() {
        
        if floatingButton.toggleFloatingButton {
            // prevent search bar to toggle when floating action butten is currently in-use
            if !headerSearchBar.searchWidget.isSearchMode {
                headerSearchBar.searchWidget.toggleSearchBar()
            }
            searchResultViewAnimateIn()
            
        } else {
            // prevent search bar to toggle floating action button is not in use.
            if headerSearchBar.searchWidget.isSearchMode {
                headerSearchBar.searchWidget.toggleSearchBar()
            }
            searchResultViewAnimateOut()
        }
    }
}

// MARK: - Delegate
extension StocksController: FloatingButtonDelegate {
    
    func floatingButtonTapped() {
        toggleActionWithAnimation()
    }
}
