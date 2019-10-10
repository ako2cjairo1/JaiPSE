//
//  StocksCellView.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/9/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksCellView: UICollectionViewCell {
    
    // MARK: - Properties
    // TODO: make this to a data model property
    var testVariable: String?
    
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
        view.addSubview(priceLabel)
        view.addSubview(percentageStack)
        view.addSubview(volumeStack)
        
        return view
    }()
    
    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.text = "JFC"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
//        label.layer.borderWidth = 0.5
//        label.layer.borderColor = UIColor.white.cgColor
        
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.contentMode = .scaleAspectFill
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.text = ("Jollibee Foods Corp. and Friends").uppercased()
        label.textAlignment = .left
        label.textColor = .darkGray
        
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "1234.00"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0.6500428082, blue: 0, alpha: 1) // TODO: Changes depending on prev opening price
        
        
        return label
    }()
    
    lazy var percentageStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalCentering
        
        stack.addArrangedSubview(percentChangeImageView)
        percentChangeImageView.anchorExt(top: stack.topAnchor,
                                         leading: stack.leadingAnchor,
                                         bottom: stack.bottomAnchor,
                                         width: 25, height: 25)
        
        stack.addArrangedSubview(percentChangeLabel)
        percentChangeLabel.anchorExt(top: stack.topAnchor,
                                     leading: percentChangeImageView.trailingAnchor, paddingLead: 5,
                                     bottom: stack.bottomAnchor)
        return stack
    }()
    
    lazy var percentChangeLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "1.80 %"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0, green: 0.6500428082, blue: 0, alpha: 1) // TODO: Changes depending on prev opening price
        
        return label
    }()
    
    lazy var percentChangeImageView: UIImageView = {
        // TODO: Changes depending on prev opening price
        guard let img = UIImage(systemName: "arrow.up.arrow.down.circle") else { return UIImageView() }
        
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .orange
        
        return iv
    }()
    
    lazy var volumeStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalCentering
        
        stack.addArrangedSubview(volumeImageView)
        volumeImageView.anchorExt(top: stack.topAnchor,
                                         leading: stack.leadingAnchor,
                                         bottom: stack.bottomAnchor,
                                         width: 25, height: 25)
        
        stack.addArrangedSubview(volumeLabel)
        volumeLabel.anchorExt(top: stack.topAnchor,
                                     leading: volumeImageView.trailingAnchor, paddingLead: 5,
                                     bottom: stack.bottomAnchor)
        return stack
    }()
    
    lazy var volumeLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .scaleAspectFill
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "123456.78"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // TODO: Changes depending on prev opening price
        
        return label
    }()
    
    lazy var volumeImageView: UIImageView = {
        // TODO: Changes depending on prev opening price
        guard let img = UIImage(systemName: "waveform.path.badge.plus") else { return UIImageView() }
        
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .yellow
        
        return iv
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
        let cellQuadrantWidth = (frame.width / 2) - 20
        
        addSubview(cellContainerView)
        cellContainerView.anchorExt(centerHorizontal: centerXAnchor,
                                    centerVertical: centerYAnchor,
                                    width: frame.width - 16, height: 100)
        
        symbolLabel.anchorExt(top: cellContainerView.topAnchor, paddingTop: 8,
                              leading: cellContainerView.leadingAnchor, paddingLead: 8,
                              width: cellQuadrantWidth)
        
        nameLabel.anchorExt(top: symbolLabel.bottomAnchor, paddingTop: 3,
                            leading: cellContainerView.leadingAnchor, paddingLead: 8,
                            width: cellQuadrantWidth)
        
        priceLabel.anchorExt(top: cellContainerView.topAnchor, paddingTop: 8,
                             trailing: cellContainerView.trailingAnchor, paddingTrail: 8,
                             width: cellQuadrantWidth)
        
        percentageStack.anchorExt(top: priceLabel.bottomAnchor, paddingTop: 10,
                                  trailing: cellContainerView.trailingAnchor, paddingTrail: 8,
                                  width: cellQuadrantWidth)
        
        volumeStack.anchorExt(top: percentageStack.bottomAnchor, paddingTop: 5,
                                  trailing: cellContainerView.trailingAnchor, paddingTrail: 8,
                                  width: cellQuadrantWidth)
    }
}
