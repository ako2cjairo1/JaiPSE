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
        guard let img = UIImage(systemName: "plus") else { return }
        
        setImage(img, for: .normal)
        tintColor = .white
        backgroundColor = #colorLiteral(red: 0.9027048945, green: 0.1456339359, blue: 0.1390642822, alpha: 1)
        
        layer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer.cornerRadius = (frame.height / 2)
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc
    func tapAction() {
        toggleFloatingButton = !toggleFloatingButton
        delegate?.floatingActionButtonTapped()
    }

}
