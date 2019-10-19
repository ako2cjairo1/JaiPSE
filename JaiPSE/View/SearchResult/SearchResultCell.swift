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
            stockCode.text = stockData?.symbol
            stockName.text = stockData?.name
        }
    }
    
    lazy var stockCode: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    lazy var stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    var cellAddButton: UIButton = {
        let button = UIButton()
//        button.imageView?.image = UIImage(systemName: "plus.circle")
//        button.setTitle("ADD", for: .normal)
        button.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        
        return button
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
        addSubview(cellAddButton)
        addSubview(stockName)
        
        stockCode.anchorExt(top: topAnchor,
                            leading: leadingAnchor, paddingLead: 16,
                            bottom: bottomAnchor,
                            centerVertical: centerYAnchor, width: 80)
        
        cellAddButton.anchorExt(top: topAnchor,
                                leading: stockName.trailingAnchor, paddingLead: 5,
                                bottom: bottomAnchor,
                                trailing: trailingAnchor, paddingTrail: 5,
                                centerVertical: centerYAnchor,
                                width: frame.height)
        
        stockName.anchorExt(top: topAnchor,
                            leading: stockCode.trailingAnchor, paddingLead: 10,
                            bottom: bottomAnchor,
                            trailing: cellAddButton.leadingAnchor,
                            centerVertical: centerYAnchor,
                            height: 30)
        
        let img = UIImage(systemName: "plus.circle")
        cellAddButton.setBackgroundImage(img, for: .normal)
        
    }

}
