//
//  UIViewExtension.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchorExt(top: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0, leading: NSLayoutXAxisAnchor? = nil, paddingLead: CGFloat? = 0, bottom: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat? = 0, trailing: NSLayoutXAxisAnchor? = nil, paddingTrail: CGFloat? = 0, centerHorizontal: NSLayoutXAxisAnchor? = nil, centerVertical: NSLayoutYAxisAnchor? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLead!).isActive = true
        }
        if let bottom = bottom {
            if let padBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: padBottom > 0 ? -padBottom : 0).isActive = true
            }
        }
        if let trailing = trailing {
            if let padRight = paddingTrail {
                trailingAnchor.constraint(equalTo: trailing, constant: padRight > 0 ? -padRight : 0).isActive = true
            }
        }
        
        if let centerX = centerHorizontal {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerVertical {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
