//
//  CatView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import UIKit

class CatView: UIView {
    
    lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    } (UIImageView())

    lazy var fireButton: FireButton = {
        $0.setImage(.init(systemName: "arrow.clockwise.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setState(to: .still)
        $0.tintColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    } (FireButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        backgroundColor = .white
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        addSubview(fireButton)
        NSLayoutConstraint.activate([
            fireButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fireButton.widthAnchor.constraint(equalToConstant: 49),
            fireButton.heightAnchor.constraint(equalToConstant: 49),
            fireButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -21)
        ])
    }
    
}
