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
            searchResultTV.reloadData()
            numberOfResult.text = "\(searchResultData.count > 0 ? String(describing: searchResultData.count) : "No") result(s) found."
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
    
    lazy var searchResultTV: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .grouped)
        return tv
    }()
    
    lazy var numberOfResult: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = nil
        label.textColor = .white
        
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
        
        addSubview(searchResultTV)
        searchResultTV.anchorExt(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           centerHorizontal: centerXAnchor,
                           centerVertical: centerYAnchor,
                           width: frame.width, height: frame.height)
        searchResultTV.rowHeight = 40
        searchResultTV.layer.cornerRadius = 25
        searchResultTV.backgroundColor = .darkGray
        
        searchResultTV.tableHeaderView?.addSubview(numberOfResult)
        numberOfResult.anchorExt(top: searchResultTV.tableHeaderView?.topAnchor,
                                 leading: searchResultTV.tableHeaderView?.leadingAnchor,
                                 trailing: searchResultTV.tableHeaderView?.trailingAnchor,
                                 height: 50)
        
        searchResultTV.tableFooterView?.addSubview(UIView(frame: .init(x: 0, y: 0, width: 400, height: superview?.safeAreaInsets.bottom ?? 50)))
        
        searchResultTV.register(SearchResultCell.self, forCellReuseIdentifier: String(describing: SearchResultCell.self))
        searchResultTV.dataSource = self
        searchResultTV.delegate = self
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
        
        cell.stockData = searchResultData[indexPath.row]
        return cell
    }
}

extension SearchResultTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        addSubview(numberOfResult)
        numberOfResult.anchorExt(top: topAnchor,
                                 leading: leadingAnchor,
                                 trailing: trailingAnchor,
                                 height: 30)
        return numberOfResult
    }
}
