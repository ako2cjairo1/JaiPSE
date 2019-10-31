//
//  StocksDetailView.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/28/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation
import UIKit

class StocksDetailView: UIView {
    
    // MARK: - Properties
    var stockData: StockViewModel? {
        didSet {
            nameLabel.text = self.stockData?.name
        }
    }
    var parentView = UIView()
    
    lazy var blurredEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView()
        
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.frame = parentView.frame
        return effectView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 0.5
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    func setupCardView(toViewContainer: UIView) {
        let cardWidth: CGFloat = 250
        self.parentView = toViewContainer
         backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.cornerRadius = 15
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 20
        alpha = 0
        
        parentView.addSubview(blurredEffectView)
        parentView.addSubview(self)
        
        self.anchorExt(centerHorizontal: parentView.centerXAnchor,
                       centerVertical: parentView.centerYAnchor,
                       width: cardWidth, height: 350)
        
        self.addSubview(nameLabel)
        nameLabel.anchorExt(top: self.topAnchor, paddingTop: 20,
                            centerHorizontal: self.centerXAnchor,
                            width: cardWidth - 20, height: 40)
        
        blurredEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeModal)))
        
        animateIn()
    }
    
    @objc
    func closeModal() {
        animateOut()
    }
    
    fileprivate func animateIn() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.blurredEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurredEffectView.alpha = 1
            
        }, completion: {
            (success) in
            if success {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.transform = .identity
                    self.alpha = 1
                })
            }
        })
    }
    
    fileprivate func animateOut() {
        self.transform = .identity
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: {
            (success) in
            if success {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.blurredEffectView.alpha = 1
                    self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    self.alpha = 1
                    
                }) {
                    (success) in
                    if success {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.alpha = 0
                            self.blurredEffectView.alpha = 0
                            
                        }, completion: {
                            (success) in
                            if success {
                                self.blurredEffectView.removeFromSuperview()
                                self.removeFromSuperview()
                            }
                        })
                    }
                }
            }
        })
        
    }
}


