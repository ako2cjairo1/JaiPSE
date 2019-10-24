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
    var stockData: StockViewModel? {
        didSet {
            if let symbol = self.stockData?.symbol {
                stockCode.text = symbol
            }
            if let name = self.stockData?.name {
                stockName.text = name
            }
            if let price = self.stockData?.price {
                stockPrice.text = "\(price)"
            }
            if let percent = self.stockData?.percentChange {
                var formattedPercent: String = "0.00"
                
                if percent < 0 {
                    formattedPercent = String(format: "%.2f", percent)
                    stockPercentChange.textColor = .white
                    stockPercentChange.backgroundColor = #colorLiteral(red: 0.9645465016, green: 0.2221286595, blue: 0.182257086, alpha: 1)
                    stockPercentChange.layer.borderColor = stockPercentChange.backgroundColor?.cgColor
                    
                } else if percent > 0 {
                    formattedPercent = "+\(String(format: "%.2f", percent))"
                    stockPercentChange.textColor = .white
                    stockPercentChange.backgroundColor = #colorLiteral(red: 0.2797255516, green: 0.8248286843, blue: 0.3802976012, alpha: 1)
                    stockPercentChange.layer.borderColor = stockPercentChange.backgroundColor?.cgColor
                }
                
                stockPercentChange.text = " \(formattedPercent)%."
            }
        }
    }
    
    var stockCellContainerView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.cellBgColor
        //        view.layer.borderColor = UIColor.darkGray.cgColor
        //        view.layer.borderWidth = 0.5
        //view.layer.cornerRadius = 7
//        view.layer.shadowOffset = CGSize(width: 1, height: 1)
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowRadius = 2
//        view.layer.shadowColor = UIColor.white.cgColor
        
        view.backgroundColor = .cellBgColor
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 2, height: 6)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        
        return view
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "plus.circle.fill")
        button.setBackgroundImage(img, for: .normal)
        button.tintColor = #colorLiteral(red: 0.1946504414, green: 0.7753459811, blue: 0.3262496591, alpha: 1)
//        button.layer.backgroundColor = UIColor.white.cgColor
//        button.layer.cornerRadius = 12.5
//        button.layer.masksToBounds = true
        
//        button.layer.borderColor = UIColor.red.cgColor
//        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    lazy var stockCodeAndNameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stockCode, stockName])
        stack.axis = .vertical
        stack.contentMode = .scaleAspectFill
        stack.distribution = .fill
        
        return stack
    }()
    
    lazy var stockCode: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 0.5
        
        return label
    }()
    
    lazy var stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightText
        label.allowsDefaultTighteningForTruncation = true
        
//         label.layer.borderColor = UIColor.red.cgColor
//         label.layer.borderWidth = 0.5
        
        return label
    }()
    
    lazy var stockPriceAndPercentStack: UIView = {
        let view = UIView()
//        view.layer.borderColor = UIColor.red.cgColor
//        view.layer.borderWidth = 0.5
        
        view.addSubview(self.stockPercentChange)
        view.addSubview(self.stockPrice)
//        self.stockPercentChange.anchorExt(top: view.topAnchor, trailing: view.trailingAnchor, height: 15)
//        self.stockPrice.anchorExt(top: self.stockPercentChange.bottomAnchor, trailing: view.trailingAnchor)
        self.stockPrice.anchorExt(top: view.topAnchor, trailing: view.trailingAnchor, height: 25)
        self.stockPercentChange.anchorExt(top: self.stockPrice.bottomAnchor, trailing: view.trailingAnchor)
        
        return view
    }()
    
    lazy var stockPercentChange: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .right
        label.backgroundColor = .lightGray
        
        label.layer.borderColor = label.backgroundColor?.cgColor
        label.layer.cornerRadius = 7
        label.layer.borderWidth = 2
        label.layer.masksToBounds = true
        
        return label
    }()
    
    lazy var stockPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .white
        
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 0.5
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
        backgroundColor = .clear
        
        addSubview(stockCellContainerView)
        stockCellContainerView.addSubview(addButton)
        stockCellContainerView.addSubview(stockCodeAndNameStack)
        stockCellContainerView.addSubview(stockPriceAndPercentStack)
        
        // setup container view's anchors
        stockCellContainerView.anchorExt(top: topAnchor, paddingTop: 2,
                                         leading: leadingAnchor, paddingLead: 10,
                                         bottom: bottomAnchor, paddingBottom: 2,
                                         trailing: trailingAnchor, paddingTrail: 10)
        
        addButton.anchorExt(leading: stockCellContainerView.leadingAnchor, paddingLead: 16,
                            centerVertical: stockCellContainerView.centerYAnchor,
                            width: 25, height: 25)
        
        stockPriceAndPercentStack.anchorExt(trailing: stockCellContainerView.trailingAnchor, paddingTrail: 16,
                                            centerVertical: stockCellContainerView.centerYAnchor,
                                            width: 80, height: 40)
        
        stockCodeAndNameStack.anchorExt(leading: addButton.trailingAnchor, paddingLead: 16,
                                        trailing: stockPriceAndPercentStack.leadingAnchor,
                                        centerVertical: centerYAnchor)
    }
    
}
