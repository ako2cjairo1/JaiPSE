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
    func searchBarTapped(searchKeyword: String?)
}

class SearchWidget: UIView {
    
    // MARK: - Properties
    var isSearching: Bool = false
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
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .darkGray
        searchBar.placeholder = "Company name / Stock Code"
        searchBar.delegate = self
        searchBar.alpha = 0
        
        return searchBar
    }()
    
    @objc
    func onSearch() {
        if let value = searchBar.text {
            print(value)
        }
    }
    
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
    @objc
    func searchStock() {
        toggleSearchBar()
        
        if let delegate = delegate {
            delegate.searchButtonTapped()
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
    
    func toggleSearchBar() {
        let fontSize: CGFloat = (isSearching ? 20 : 40)
        searchTitle.font = UIFont(descriptor: UIFontDescriptor(name: "Pacifico-Regular", size: fontSize), size: fontSize)
        
        let img = UIImage(systemName: (isSearching ? "xmark.circle.fill" : "magnifyingglass.circle.fill"))
        searchButton.setBackgroundImage(img, for: .normal)
        searchBar.alpha = isSearching ? 1 : 0
        
        animate()
        isSearching = !isSearching
    }
    
    private func animate() {
        searchButton.transform = CGAffineTransform(rotationAngle: 180)
        searchButton.layer.shadowOpacity = 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.searchButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            let fontSize: CGFloat = (self.isSearching ? 20 : 40)
            self.searchTitle.font = UIFont(descriptor: UIFontDescriptor(name: "Pacifico-Regular", size: fontSize), size: fontSize)
        }, completion: {
            if $0 {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.searchButton.transform = .identity
                    self.searchButton.layer.shadowOpacity = 0.4
                    self.searchButton.layer.shadowOffset = CGSize(width: 0, height: 3)
                    self.searchButton.layer.shadowRadius = 2
                })
            }
        })
    }
}

extension SearchWidget: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarTapped(searchKeyword: searchBar.text)
        //        searchBar.resignFirstResponder()
    }
}
