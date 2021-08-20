//
//  UIColor.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 19.08.2021.
//

import UIKit

extension UIColor {
    
    static func hex(_ hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha)
    }
    
}

extension UIColor {
    
    // MARK: - Backgrounds
    
    static var backgroundLightPink: UIColor {
        return .hex(0xF6E7EE)
    }
    
    // MARK: - Fonts
    
    static var fontBlack: UIColor {
        return .hex(0x1F1F1F)
    }
    
    // MARK: - Accents
    
    static var accentPink: UIColor {
        return .hex(0xFFA5A0)
    }
    
}
