//
//  MainInputView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 24.08.2021.
//

import UIKit
import Combine

class MainInputView: UIView {
    
    enum Mode {
        case active
        case suspended
    }
    
    @Published var mode: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var closeButton: UIButton = {
        $0.setImage(.init(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageView?.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .hex(0xEEEEEF)
        NSLayoutConstraint.activate([
            $0.imageView!.widthAnchor.constraint(equalTo: $0.widthAnchor),
            $0.imageView!.heightAnchor.constraint(equalTo: $0.heightAnchor)
        ])
        return $0
    } (RoundedButton())
    
    private lazy var textView: UITextView = {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .fontBlack
        $0.isScrollEnabled = false
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UITextView())
    
    private lazy var placeholderLabel: UILabel = {
        $0.text = "Enter text"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .hex(0xDCDCDC)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var activeTextViewConstraint: NSLayoutConstraint = {
        let constraint = textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 5)
        constraint.priority = .init(rawValue: 999)
        return constraint
    }()
    
    private lazy var suspendedTextViewConstraint: NSLayoutConstraint = {
        let constraint = textView.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        constraint.priority = .init(rawValue: 998)
        return constraint
    }()
    
    private func fill() {
        backgroundColor = .white
        
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            suspendedTextViewConstraint,
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor)
        ])
        
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
        
        closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        
        NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification, object: textView)
            .sink { [unowned self] _ in
                mode = true
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: textView)
            .compactMap { $0.object as? UITextView }
            .sink { [unowned self] value in
                placeholderLabel.isHidden = !(value.text?.isEmpty ?? true)
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UITextView.textDidEndEditingNotification, object: textView)
            .sink { [unowned self] _ in
                resetState()
            }
            .store(in: &cancellable)
        
        $mode
            .sink { [unowned self] mode in
                closeButton.isHidden = !mode
                activeTextViewConstraint.isActive = mode
                if mode { textView.selectAll(self) }
            }
            .store(in: &cancellable)
    }
    
    @objc
    private func handleTapGesture() {
        if !mode { mode.toggle() }
    }
    
    @objc
    private func handleCloseButtonTap() {
        if mode { mode.toggle() }
        resetState()
        textView.resignFirstResponder()
    }
    
    private func resetState() {
        textView.text = ""
        placeholderLabel.isHidden = false
    }
    
}
