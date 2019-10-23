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
    
    var stockCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.layer.borderColor = UIColor.darkGray.cgColor
//        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.white.cgColor
        
        return view
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stockCode, stockName])
        stack.axis = .vertical
        stack.contentMode = .scaleAspectFill
        stack.distribution = .fill
        
        return stack
    }()
    
    lazy var stockCode: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        
        return label
    }()
    
    lazy var stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3

        return label
    }()
    
    var cellAddButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "plus.circle.fill")
        button.setBackgroundImage(img, for: .normal)
        button.tintColor = #colorLiteral(red: 0.1946504414, green: 0.7753459811, blue: 0.3262496591, alpha: 1)
        
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
        backgroundColor = .clear
        
        addSubview(stockCellView)
        stockCellView.addSubview(cellAddButton)
        stockCellView.addSubview(stack)
        
        // setup component's anchors
        stockCellView.anchorExt(top: topAnchor, paddingTop: 2,
                                leading: leadingAnchor, paddingLead: 10,
                                bottom: bottomAnchor, paddingBottom: 2,
                                trailing: trailingAnchor, paddingTrail: 10)
        
        cellAddButton.anchorExt(leading: stockCellView.leadingAnchor, paddingLead: 16,
                                centerVertical: stockCellView.centerYAnchor,
                                width: 25, height: 25)
        
        stack.anchorExt(leading: cellAddButton.trailingAnchor, paddingLead: 16,
                        trailing: stockCellView.trailingAnchor, paddingTrail: 16,
                        centerVertical: centerYAnchor)
        
    }

}
