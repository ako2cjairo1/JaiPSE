//
//  StocksCellView.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/9/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var stockData: StockViewModel? {
        didSet {
            if let symbol = self.stockData?.symbol {
                self.symbolLabel.text = symbol.uppercased()
            }
            
            if let name = self.stockData?.name {
                self.nameLabel.text = name.uppercased()
            }
            
            if let price = self.stockData?.price {
                self.priceLabel.text = "\(price)"
            }
            
            if let percent = self.stockData?.percentChange {
                var formattedPercent = String(format: "%.2f", percent)
                var tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                
                if percent < 0 {
                    tintColor = #colorLiteral(red: 0.9645465016, green: 0.2221286595, blue: 0.182257086, alpha: 1)
                    
                } else if percent > 0 {
                    formattedPercent = "+\(formattedPercent)"
                    tintColor = #colorLiteral(red: 0.2797255516, green: 0.8248286843, blue: 0.3802976012, alpha: 1)
                }
                
                self.percentChangeLabel.textColor = tintColor
                self.percentChangeLabel.text = "\(formattedPercent)%"
            }
            
            if let volume = self.stockData?.volume {
                self.volumeLabel.text = "\(volume)"
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .cellBgColor
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 2, height: 6)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        
        view.addSubview(symbolLabel)
        view.addSubview(nameLabel)
        view.addSubview(unwatchButton)
        view.addSubview(priceLabel)
        view.addSubview(percentChangeLabel)
        view.addSubview(volumeLabel)
        view.addSubview(activityIndicator)
        
        return view
    }()
    
    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .top
        label.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.contentMode = .top
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.allowsDefaultTighteningForTruncation = true
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    var unwatchButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Unwatch", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.tintColor = .black
        button.layer.cornerRadius = 7.5
        button.backgroundColor = .darkGray
        return button
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return label
    }()
    
    lazy var percentChangeLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    lazy var volumeLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
        // 2 cells per row
        let cellQuadrantWidth = (frame.width / 2) - 20
        
        addSubview(cellContainerView)
        cellContainerView.anchorExt(centerHorizontal: centerXAnchor,
                                    centerVertical: centerYAnchor,
                                    width: frame.width - 16, height: 100)
        
        symbolLabel.anchorExt(top: cellContainerView.topAnchor, paddingTop: 8,
                              leading: cellContainerView.leadingAnchor, paddingLead: 8,
                              width: cellQuadrantWidth + 5, height: 30)
        
        nameLabel.anchorExt(top: symbolLabel.bottomAnchor, paddingTop: 0,
                            leading: cellContainerView.leadingAnchor, paddingLead: 8,
                            width: cellQuadrantWidth + 5)
        
        unwatchButton.anchorExt(leading: cellContainerView.leadingAnchor, paddingLead: 17,
                                bottom: cellContainerView.bottomAnchor, paddingBottom: 14,
                                width: cellQuadrantWidth - 15, height: 15)
        
        priceLabel.anchorExt(top: cellContainerView.topAnchor, paddingTop: 16,
                             trailing: cellContainerView.trailingAnchor, paddingTrail: 8,
                             width: cellQuadrantWidth)
        
        percentChangeLabel.anchorExt(top: priceLabel.bottomAnchor, paddingTop: 5,
                                     trailing: cellContainerView.trailingAnchor, paddingTrail: 8,
                                     width: cellQuadrantWidth)
        
        volumeLabel.anchorExt(top: percentChangeLabel.bottomAnchor, paddingTop: 5,
                              trailing: cellContainerView.trailingAnchor, paddingTrail: 8,
                              width: cellQuadrantWidth)
        
        activityIndicator.anchorExt(centerHorizontal: centerXAnchor,
                               centerVertical: centerYAnchor,
                               width: 50, height: 50)
    }
}
