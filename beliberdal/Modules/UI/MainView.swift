//
//  MainView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit

class MainView: UIView {
    
    class MainViewTopBar {
        
        
        
    }
    
    lazy var button: UIButton = {
        $0.setTitle("Fire!", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIButton())
    
    lazy var button1: UIButton = {
        $0.setTitle("Mode", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        backgroundColor = .yellow
        
        addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(button1)
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: centerXAnchor),
            button1.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30)
        ])
    }
    
}
