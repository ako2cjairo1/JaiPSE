//
//  StocksHeader.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/9/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    var searchWidget = SearchWidget()
    
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
        addSubview(searchWidget)
        
        // Constraints
        searchWidget.anchorExt(top: topAnchor, paddingTop: -5, leading: leadingAnchor, trailing: trailingAnchor, height: 140)
    }
}
