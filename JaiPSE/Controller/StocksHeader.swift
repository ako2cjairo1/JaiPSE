//
//  StocksHeader.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/9/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Functions
    
    fileprivate func setupViews() {
        let searchView = SearchWidget()
        
        addSubview(searchView)
        
        // Constraints
        searchView.anchorExt(top: topAnchor, paddingTop: -5, leading: leadingAnchor, trailing: trailingAnchor, height: 140)
    }
    
}
