//
//  SearchResultCell.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/11/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    // MARK: - Properties
    var stockData: Stock? {
        didSet {
            print("stockData received...")
            stockCode.text = stockData?.symbol
            stockName.text = stockData?.name
        }
    }
    
    lazy var stockCode: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .right
        
//        label.layer.borderWidth = 0.5
//        label.layer.borderColor = UIColor.red.cgColor
        
        return label
    }()
    
    lazy var stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        
//        label.layer.borderWidth = 0.5
//        label.layer.borderColor = UIColor.red.cgColor
        
        return label
    }()
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    // MARK: - Lifecycle
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {        
        addSubview(stockCode)
        addSubview(stockName)
        
        stockCode.anchorExt(top: topAnchor,
                            leading: leadingAnchor, paddingLead: 16,
                            bottom: bottomAnchor,
                            centerVertical: centerYAnchor, width: 100, height: 30)
        
        stockName.anchorExt(top: topAnchor,
                            leading: stockCode.trailingAnchor, paddingLead: 10,
                            bottom: bottomAnchor,
                            centerVertical: centerYAnchor, width: frame.width / 2, height: 30)
    }

}
