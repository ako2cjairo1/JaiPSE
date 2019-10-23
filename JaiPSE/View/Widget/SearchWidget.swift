//
//  SearchWidget.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation
import UIKit

protocol SearchButtonDelegate {
    /// A delegate function of SearchWidget (custom class) that responds to when the search image button was tapped.
    func searchButtonTapped()
    /// A delegate function of SearchWidget (custom class) that responds to when the "Search" key was tapped.
    func searchBarTapped(searchKeyword: String?)
}

class SearchWidget: UIView {
    
    // MARK: - Properties
    var isSearchMode: Bool = true {
        didSet {
    
            let titleFontSize: CGFloat = (isSearchMode ? 30 : 50)
            titleLabel.font = UIFont.boldSystemFont(ofSize: titleFontSize)
            
            let dateFontSize: CGFloat = (isSearchMode ? 15 : 20)
            dateLabel.font = UIFont.boldSystemFont(ofSize: dateFontSize)
            
            if titleStack.subviews.count > 0 {
                titleStack.removeArrangedSubview(titleLabel)
                titleStack.removeArrangedSubview(dateLabel)
            }
            
            if isSearchMode {
                titleStack.axis = .horizontal
                titleStack.alignment = .top
                searchBar.alpha = 1
                
                titleStack.addArrangedSubview(titleLabel)
                titleStack.addArrangedSubview(dateLabel)
                
            } else {
                titleStack.axis = .vertical
                titleStack.alignment = .leading
                
                titleStack.addArrangedSubview(dateLabel)
                titleStack.addArrangedSubview(titleLabel)
                // hides the searchbar
                searchBar.alpha = 0
            }
            
            let img = UIImage(systemName: (isSearchMode ? "xmark.circle.fill" : "magnifyingglass.circle.fill"))
            searchButton.setBackgroundImage(img, for: .normal)
            
        }
    }
    var delegate: SearchButtonDelegate?
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel, titleLabel])
        stack.distribution = .fill
        
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.textColor = .darkText
        
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 0.5
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        
        label.text = formatter.string(from: Date())
        label.textAlignment = .right
        label.textColor = .darkGray
        
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 0.5
        
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(searchStock), for: .touchUpInside)
        button.tintColor = .darkGray
        
//        button.layer.borderColor = UIColor.red.cgColor
//        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.layer.borderColor = UIColor.orange.cgColor
        searchBar.searchTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        searchBar.tintColor = .darkGray
        searchBar.placeholder = "Company name or Stock Code"
        searchBar.delegate = self
        
//        searchBar.layer.borderColor = UIColor.red.cgColor
//        searchBar.layer.borderWidth = 0.5
        
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
    @objc
    func searchStock() {
        if let delegate = delegate {
            delegate.searchButtonTapped()
            toggleSearchBar()
        }
    }
    
    // MARK: - Lifecycle
    fileprivate func superView() {
        backgroundColor = .searchContainerBgColor
        layer.cornerRadius = 25
        layer.masksToBounds = true
        
        // shadow
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        
        addSubview(titleStack)
        addSubview(searchButton)
        addSubview(searchBar)
        setAnchors()
        
        // toggle from searchbar to header title bar (and vice versa)
        toggleSearchBar()
    }
    
    fileprivate func setAnchors() {
        titleStack.anchorExt(top: topAnchor, paddingTop: 45, leading: leadingAnchor, paddingLead: 16, trailing: trailingAnchor, paddingTrail: 16)
        searchBar.anchorExt(top: titleStack.bottomAnchor, leading: leadingAnchor, paddingLead: 12, trailing: searchButton.leadingAnchor, paddingTrail: 7, height: 45)
        searchButton.anchorExt(bottom: bottomAnchor, paddingBottom: 18, trailing: trailingAnchor, paddingTrail: 16, width: 40, height: 40)
    }
    
    fileprivate func animate() {
        searchButton.transform = CGAffineTransform(rotationAngle: 180)
        searchButton.layer.shadowOpacity = 0
        
        UIView.animate(withDuration: 0.8, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: {
                            self.searchButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            self.layoutIfNeeded()
                        },
                       completion: { (success) in
                            if success {
                                /*if self.isSearchMode {
                                    self.titleStack.alignment = .bottom
                                } else {
                                    self.titleStack.alignment = .top
                                }*/
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.searchButton.transform = .identity
                                    self.searchButton.layer.shadowOpacity = 0.4
                                    self.searchButton.layer.shadowOffset = CGSize(width: 0, height: 3)
                                    self.searchButton.layer.shadowRadius = 2
                                    self.layoutIfNeeded()
                                })
                                
                                // hide/show the keyboard
                                if self.isSearchMode {
                                    self.searchBar.becomeFirstResponder()
                                } else {
                                    self.searchBar.resignFirstResponder()
                                }
                            }
                        })
    }
    
    func toggleSearchBar() {
        isSearchMode = !isSearchMode
        animate()
    }
}

extension SearchWidget: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let delegate = delegate {
            delegate.searchBarTapped(searchKeyword: searchBar.text)
        }
        
        // hides the keyboard when "Search" key was clicked.
        searchBar.resignFirstResponder()
    }
}
