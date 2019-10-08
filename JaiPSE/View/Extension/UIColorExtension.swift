//
//  UIColorExtension.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainContainerBgColor = UIColor.rgb(18, 20, 33)
    static let searchContainerBgColor = UIColor.lightGray
    static let cellBgColor = UIColor.rgb(24, 30, 45)
}
