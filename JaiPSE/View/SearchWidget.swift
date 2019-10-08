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
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "magnifyingglass.circle.fill")
        button.setBackgroundImage(img, for: .normal)
        button.addTarget(self, action: #selector(seachButtonPressed), for: .touchUpInside)
        button.tintColor = .darkGray
        return button
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
    
    // MARK: - Selectors
    
    @objc func seachButtonPressed() {
        // TODO: seems not animating :(
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
            self.searchTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            self.searchTitle.anchorExt(leading: self.leadingAnchor, paddingLead: 16,
                                       bottom: self.bottomAnchor, paddingBottom: 40)
        }
    }
    
    // MARK: - Functions
    
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
        
        addSubview(searchButton)
        searchButton.anchorExt(bottom: bottomAnchor, paddingBottom: 20,
                               trailing: trailingAnchor, paddingTrail: 16,
                               width: 45,
                               height: 45)
    }

}
