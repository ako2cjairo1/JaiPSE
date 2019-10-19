//
//  FloatingActionButtonWidget.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/10/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

protocol FloatingActionButtonDelegate {
    func floatingActionButtonTapped()
}

class FloatingActionButtonWidget: UIButton {
    
    // MARK: - Properties
    var toggleFloatingButton: Bool = false
    var delegate: FloatingActionButtonDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtonView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButtonView()
    }
    
    // MARK: - Lifecycle
    private func setupButtonView() {
        guard let img = UIImage(systemName: "plus.circle.fill") else { return }
        setBackgroundImage(img, for: .normal)
        
        tintColor = #colorLiteral(red: 0.9027048945, green: 0.1456339359, blue: 0.1390642822, alpha: 1)
        backgroundColor = .white
        layer.cornerRadius = 25
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        
        toggleAnimation()
    }
    
    // MARK: - Selectors
    @objc
    func tapAction() {
        toggleFloatingButton = !toggleFloatingButton
        toggleAnimation()
        delegate?.floatingActionButtonTapped()
    }

    func toggleAnimation() {
        
        if toggleFloatingButton {
            // Animate IN
            transform = .identity
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.transform = CGAffineTransform(rotationAngle: 40)
                self.layer.shadowOffset = CGSize(width: 0, height: -10)
            })
        } else {
            // Animate OUT
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.transform = CGAffineTransform(rotationAngle: 40)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.layer.shadowOffset = CGSize(width: 0, height: 10)
                self.layer.shadowOpacity = 0.40
                self.layer.shadowRadius = 10
                self.transform = .identity
            })
        }
        
    }
}
