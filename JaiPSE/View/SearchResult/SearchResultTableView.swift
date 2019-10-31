//
//  SearchResultTableView.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/11/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class SearchResultTableView: UIView {
    
    // MARK: - Properties
    var searchResultData = [StockViewModel]() {
        didSet {
            searchResultTableView.reloadData()
            updateNumberOfResult()
        }
    }
    
    var isHideSearchResult = false {
        didSet {
            if self.isHideSearchResult {
                // remove result data when explicitly indicated
                searchResultData = [StockViewModel]()
            }
        }
    }
    
    var searchResultTableView: UITableView = {
        let tv = UITableView()
        
        tv.rowHeight = 65
        tv.layer.cornerRadius = 25
        tv.backgroundColor = .darkGray
        tv.separatorStyle = .none
        return tv
    }()
    
    var numberOfResult: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = nil
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 20
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 0, height: 15)
        label.layer.shadowRadius = 10
        label.alpha = 0
        return label
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
        backgroundColor = .clear
        addSubview(searchResultTableView)
        
        // setup component anchors
        searchResultTableView.anchorExt(top: topAnchor,
                                 leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 centerHorizontal: centerXAnchor,
                                 centerVertical: centerYAnchor,
                                 width: frame.width, height: frame.height)
        
        // Register custom cell
        searchResultTableView.register(SearchResultCell.self, forCellReuseIdentifier: String(describing: SearchResultCell.self))
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
    }
    
    private func updateNumberOfResult() {
        numberOfResult.alpha = 0
        numberOfResult.transform = CGAffineTransform(translationX: 0, y: -numberOfResult.frame.size.height)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.numberOfResult.text = "\(self.searchResultData.count > 0 ? String(describing: self.searchResultData.count) : "No") result(s) found."
            self.numberOfResult.transform = .identity
            self.numberOfResult.alpha = 1
            self.numberOfResult.layer.opacity = 0.95
        })
    }
}

extension SearchResultTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultCell.self), for: indexPath) as! SearchResultCell
        let stockDataViewModel = searchResultData[indexPath.row]
        
        cell.stockData = stockDataViewModel
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
        
        let isAddedToWatch = UserDefaultsHelper.shared.isSymbolInWatchedList(stockDataViewModel.symbol)
        // change the button image wheather symbol is already added to watlist or not.
        let img = UIImage(systemName: isAddedToWatch ? "checkmark.circle.fill" : "plus.circle.fill")
        cell.addButton.setBackgroundImage(img, for: .normal)
        cell.addButton.tintColor = isAddedToWatch ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) : #colorLiteral(red: 0.1946504414, green: 0.7753459811, blue: 0.3262496591, alpha: 1)
        cell.addButton.isUserInteractionEnabled = !isAddedToWatch
        
        return cell
    }
}

extension SearchResultTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        addSubview(numberOfResult)
        numberOfResult.anchorExt(top: topAnchor,
                                 leading: leadingAnchor,
                                 trailing: trailingAnchor,
                                 height: 40)
        return numberOfResult
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
        
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to remove highlighting effect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Selector
    @objc
    func didTapAddButton(_ sender: UIButton) {
        // prevent user to tap the Add button again
        sender.isUserInteractionEnabled = false
        
        let selectedSymbol = searchResultData[sender.tag].symbol
        // update the list of watch list in UserDefaults
        UserDefaultsHelper.shared.updateWatchedSymbols(stockSymbol: selectedSymbol)
        
        sender.transform = .identity
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            sender.layoutIfNeeded()
            
            // change the button image of to "Check" after adding to watchlist.
            let img = UIImage(systemName: "checkmark.circle.fill")
            sender.setBackgroundImage(img, for: .normal)
            sender.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            
        }, completion: {
            (success) in
            if success {
                
                UIView.animate(withDuration: 0.3) {
                    sender.transform = .identity
                }
            }
        })
    }
}
