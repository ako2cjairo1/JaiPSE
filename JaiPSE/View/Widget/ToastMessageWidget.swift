//
//  ToastMessageWidget.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/15/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class ToastMessageWidget {
    
    // MARK: - Properties
    private static let containerHeight: CGFloat = 50
    private static let containerWidth: CGFloat = UIWindow().frame.width
    
    private static var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private static var messageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        view.addSubview(messageLabel)
        messageLabel.anchorExt(leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               centerHorizontal: view.centerXAnchor,
                               centerVertical: view.centerYAnchor,
                               width: 250, height: 40)
        return view
    }()
    
    // MARK: - Init
    init(){}
    
    // MARK: - Lifecycle
    static func showMessage(toViewContainer: UIView, _ message: String) {
        messageLabel.text = message
    
        toViewContainer.addSubview(messageContainer)
        messageContainer.anchorExt(leading: toViewContainer.leadingAnchor,
                                   bottom: toViewContainer.bottomAnchor,
                                   trailing: toViewContainer.trailingAnchor,
                                   height: containerHeight)
        
        messageContainer.layer.cornerRadius = 20
        animateIn()
        animateOut()
    }
    
    fileprivate static func animateIn() {
        messageContainer.transform = CGAffineTransform(translationX: 0, y: containerHeight)
        messageContainer.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 30, options: .curveEaseOut, animations: {
            self.messageContainer.transform = CGAffineTransform(translationX: 0, y: -self.containerHeight)
            self.messageContainer.alpha = 1
        })
    }
    
    fileprivate static func animateOut() {
        messageContainer.transform = CGAffineTransform(translationX: 0, y: -containerHeight)
        messageContainer.alpha = 1
        
        UIView.animate(withDuration: 1, delay: 3, animations: {
            self.messageContainer.transform = CGAffineTransform(translationX: -self.containerWidth, y: -self.containerHeight)
            self.messageContainer.alpha = 0
        }) { (success) in
            self.messageContainer.removeFromSuperview()
        }
    }
}
