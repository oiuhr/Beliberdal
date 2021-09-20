//
//  MainView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit
import Combine

class MainView: UIView {
    
    lazy var switchModeButton: UIButton = {
        $0.accessibilityIdentifier = "settingsButton"
        return $0
    } (MainViewTopBar())
    lazy var contentView: MainContentView = .init()
    lazy var sourceInputView: MainInputView = .init()
    
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
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var suspendedInputViewConstraint = sourceInputView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
    lazy var activeInputViewConstraint = sourceInputView.topAnchor.constraint(equalTo: contentView.topAnchor)
    lazy var fireButtonBottomConstraint = fireButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -21)
    
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
            suspendedInputViewConstraint,
            activeInputViewConstraint
        ])
        activeInputViewConstraint.priority = .init(rawValue: 999)
        suspendedInputViewConstraint.priority = .init(rawValue: 998)
        
        addSubview(fireButton)
        NSLayoutConstraint.activate([
            fireButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fireButton.widthAnchor.constraint(equalToConstant: 49),
            fireButton.heightAnchor.constraint(equalToConstant: 49),
            fireButtonBottomConstraint
        ])
        
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    private func bind() {
        sourceInputView.mode
            .dropFirst()
            .sink { [weak self] value in
                UIView.animate(withDuration: 0.6, delay: .zero, usingSpringWithDamping: 100, initialSpringVelocity: 0.1, options: .curveEaseOut) {
                    self?.activeInputViewConstraint.isActive = value.active
                    self?.layoutIfNeeded()
                }
            }
            .store(in: &cancellable)
        
        contentView.tryedToEnterInput
            .sink { [weak self] _ in
                self?.sourceInputView.textView.selectAll(self)
            }
            .store(in: &cancellable)
    }
    
    func keyboardBinder(_ height: CGFloat) {
        fireButtonBottomConstraint.constant = height == 0 ? -21 : -height
        sourceInputView.bottomTextViewConstraint.constant = height == 0 ? -10 : -height
    }
    
}
