//
//  StocksCellView.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/9/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksCellView: UICollectionViewCell {
    
    // MARK: - Properties
    
    var testVariable: String?
    
    var cellView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .yellow
        
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Lifecycle
    private func setupView() {
        addSubview(cellView)
        cellView.anchorExt(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
