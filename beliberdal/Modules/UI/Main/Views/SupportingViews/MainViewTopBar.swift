//
//  MainViewTopBar.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 24.08.2021.
//

import UIKit

class MainViewTopBar: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        titleLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        setTitleColor(.fontBlack, for: .normal)
        
        setImage(.chevron?.withRenderingMode(.alwaysTemplate), for: .normal)
        imageView?.tintColor = .accentPink
        
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .left
        
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel else { return }
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - titleLabel.bounds.width - 20), bottom: 0, right: 8)
    }
    
}
