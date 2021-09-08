//
//  FavouritesTableViewCell.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 08.09.2021.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { "FavouritesTableViewCell" }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        
//        layer.cornerRadius = 8.0

//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.shadowColor = UIColor.okeyShadow.cgColor
//        layer.shadowOffset = .zero
//        layer.shadowRadius = 8.0
//        contentView.layer.cornerRadius = 8.0
//        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
}
