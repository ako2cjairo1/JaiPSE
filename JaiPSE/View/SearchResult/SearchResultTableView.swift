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
    var searchResult = [StockViewModel]() {
        didSet {
            searchTV.reloadData()
        }
    }
    
    lazy var searchTV: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .grouped)
        
        return tv
    }()
    
    lazy var numberOfResult: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "\(searchResult.count > 0 ? String(describing: searchResult.count) : "No") result(s) found."
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
        
        addSubview(searchTV)
        searchTV.anchorExt(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           centerHorizontal: centerXAnchor,
                           centerVertical: centerYAnchor,
                           width: frame.width, height: frame.height)
        searchTV.rowHeight = 40
        searchTV.layer.cornerRadius = 25
        searchTV.backgroundColor = .darkGray
        
        searchTV.tableHeaderView?.addSubview(numberOfResult)
        numberOfResult.anchorExt(top: searchTV.tableHeaderView?.topAnchor,
                                 leading: searchTV.tableHeaderView?.leadingAnchor,
                                 trailing: searchTV.tableHeaderView?.trailingAnchor,
                                 height: 30)
        
        searchTV.register(SearchResultCell.self, forCellReuseIdentifier: String(describing: SearchResultCell.self))
        searchTV.dataSource = self
        searchTV.delegate = self
    }
}

extension SearchResultTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultCell.self), for: indexPath) as! SearchResultCell
        
        cell.stockData = searchResult[indexPath.row]
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
