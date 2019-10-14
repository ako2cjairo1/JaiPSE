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
    // TODO: update this property using the actual data model
    var searchResult: [Stock] = [
        Stock(name: "Jollibee", price: StockPrice(currency: "PHP", amount: 231.20), percent_change: 0.96, volume: 186910, symbol: "JFC"),
        Stock(name: "WILCON DEPOT", price: StockPrice(currency: "PHP", amount: 6.78), percent_change: -0.12, volume: 307400, symbol: "WLCON")]
    
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
        
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .grouped)
        addSubview(tv)
        tv.anchorExt(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     centerHorizontal: centerXAnchor,
                     centerVertical: centerYAnchor,
                     width: frame.width, height: frame.height)
        tv.rowHeight = 40
        tv.layer.cornerRadius = 25
        tv.backgroundColor = .darkGray
        
        tv.tableHeaderView?.addSubview(numberOfResult)
        numberOfResult.anchorExt(top: tv.tableHeaderView?.topAnchor,
        leading: tv.tableHeaderView?.leadingAnchor,
        trailing: tv.tableHeaderView?.trailingAnchor,
        height: 30)
        
        tv.register(SearchResultCell.self, forCellReuseIdentifier: String(describing: SearchResultCell.self))
        tv.dataSource = self
        tv.delegate = self
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
