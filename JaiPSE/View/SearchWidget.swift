//
//  SearchWidget.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class SearchWidget: UIView {
    
    // MARK: - Properties
    
    private let searchTitle: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        label.textColor = .darkText
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        superView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        superView()
    }
    
    // MARK: Functions
    
    private func superView() {
        backgroundColor = UIColor.searchContainerBgColor
        layer.cornerRadius = 25
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
        // shadow
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 20

        addSubview(searchTitle)
        searchTitle.anchorExt(leading: leadingAnchor, paddingLead: 16,
                              bottom: bottomAnchor, paddingBottom: 20)
    }

}
