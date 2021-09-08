//
//  RoundedButton.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 24.08.2021.
//

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
}
