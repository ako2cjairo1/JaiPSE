//
//  SearchWidget.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

protocol SearchButtonDelegate {
    func searchButtonTapped()
}

class SearchWidget: UIView {
    
    // MARK: - Properties
    private var isSearching: Bool = false
    var delegate: SearchButtonDelegate?
    
    private let searchTitle: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.textColor = .darkText
        
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(searchStock), for: .touchUpInside)
        button.tintColor = .darkGray
        
        return button
    }()
    
    private let searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.tintColor = .darkGray
        searchBar.placeholder = "Company name / Stock Code"
        
        let img = UIImage(systemName: "magnifyingglass")
        searchBar.alpha = 0
        searchBar.becomeFirstResponder()
        
        return searchBar
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
    @objc func searchStock() {
        toggleSearchBar()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { (isSuccessful) in
            self.delegate?.searchButtonTapped()
        }
    }
    
    // MARK: - Lifecycle
    private func superView() {
        backgroundColor = .searchContainerBgColor
        layer.cornerRadius = 25
        
        // shadow
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10

        addSubview(searchTitle)
        addSubview(searchButton)
        addSubview(searchBar)
        setAnchors()
        
        // toggle from searchbar to header title bar (and vice versa)
        toggleSearchBar()
    }
    
    private func setAnchors() {
        searchTitle.anchorExt(top: topAnchor, paddingTop: 65,
                              leading: leadingAnchor, paddingLead: 16)
        
        searchButton.anchorExt(bottom: bottomAnchor, paddingBottom: 15,
                               trailing: trailingAnchor, paddingTrail: 16,
                               width: 40, height: 40)
        
        searchBar.anchorExt(top: searchTitle.bottomAnchor, paddingTop: 3,
                            leading: leadingAnchor, paddingLead: 17,
                            bottom: bottomAnchor, paddingBottom: 18,
                            trailing: searchButton.leadingAnchor, paddingTrail: 7)
    }
    
    private func toggleSearchBar() {
        let fontSize: CGFloat = (isSearching ? 20 : 65)
        searchTitle.font = UIFont(descriptor: UIFontDescriptor(name: "Pacifico-Regular", size: fontSize), size: fontSize)
    
        let img = UIImage(systemName: (isSearching ? "xmark.circle" : "magnifyingglass.circle.fill"))
        searchButton.setBackgroundImage(img, for: .normal)
        searchBar.alpha = isSearching ? 1 : 0
        
        isSearching = !isSearching
    }

}

