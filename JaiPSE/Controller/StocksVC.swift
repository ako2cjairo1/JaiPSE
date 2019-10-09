//
//  StocksVC.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksVC: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainContainerBgColor
        
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Make the status bar fonts/etc. to use light colors
        return .darkContent
    }
    
    
    // MARK: - Functions
    fileprivate func setupViews() {
        let searchView = SearchWidget()
        
        view.addSubview(searchView)
        
        // Constraints
        searchView.anchorExt(top: view.topAnchor, paddingTop: -5, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 140)
    }
}
