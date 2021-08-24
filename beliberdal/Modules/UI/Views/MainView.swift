//
//  MainView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit
import Combine

class MainView: UIView {
    
    lazy var switchModeButton: UIButton = MainViewTopBar()
    lazy var contentView: MainContentView = .init()
    lazy var sourceInputView: MainInputView = .init()
    
    lazy var fireButton: UIButton = {
        $0.setImage(.init(systemName: "arrow.clockwise.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            $0.imageView!.widthAnchor.constraint(equalTo: $0.widthAnchor),
            $0.imageView!.heightAnchor.constraint(equalTo: $0.heightAnchor)
        ])
        return $0
    } (RoundedButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var suspendedInputViewConstraint = sourceInputView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
    lazy var activeInputViewConstraint = sourceInputView.topAnchor.constraint(equalTo: contentView.topAnchor)
    
    private func fill() {
        backgroundColor = .backgroundLightPink
        
        addSubview(switchModeButton)
        NSLayoutConstraint.activate([
            switchModeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            switchModeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchModeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            switchModeButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: switchModeButton.bottomAnchor, constant: 15),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -154)
        ])
        
        addSubview(sourceInputView)
        NSLayoutConstraint.activate([
            sourceInputView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sourceInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        activeInputViewConstraint.priority = .init(rawValue: 999)
        suspendedInputViewConstraint.priority = .init(rawValue: 998)
        suspendedInputViewConstraint.isActive = true
        
        addSubview(fireButton)
        NSLayoutConstraint.activate([
            fireButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fireButton.widthAnchor.constraint(equalToConstant: 49),
            fireButton.heightAnchor.constraint(equalToConstant: 49),
            fireButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -21)
        ])
        
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    private func bind() {
        sourceInputView.$mode
            .dropFirst()
            .sink { [unowned self] value in
                UIView.animate(withDuration: 0.6, delay: .zero, usingSpringWithDamping: 100, initialSpringVelocity: 0.1, options: .curveEaseOut) {
                    activeInputViewConstraint.isActive = value
                    layoutIfNeeded()
                }
            }
            .store(in: &cancellable)
    }
    
}
