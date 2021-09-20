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
        case forced(isOpen: Bool)
        case opened
        case still
        
        var closeButtonHidden: Bool {
            switch self {
            case .forced(let isOpen):
                return !isOpen
            case .still:
                return true
            case .opened:
                return false
            }
        }
        
        var active: Bool {
            switch self {
            case .forced, .opened:
                return true
            case .still:
                return false
            }
        }
    }
    
    @Published var mode: CurrentValueSubject<Mode, Never> = .init(.forced(isOpen: false))
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
    
    lazy var textView: UITextView = {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .fontBlack
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.autocorrectionType = .no
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.returnKeyType = .go
        $0.delegate = self
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
    
    lazy var bottomTextViewConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    
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
            bottomTextViewConstraint
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
    
    let textPublisher = PassthroughSubject<String, Never>()
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
        
        closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        
        NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification, object: textView)
            .sink { [unowned self] _ in
                switch mode.value {
                case .forced(let opened):
                    if !opened { mode.value = .forced(isOpen: !opened) }
                default: mode.value = .opened
                }
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: textView)
            .compactMap { $0.object as? UITextView }
            .sink { [unowned self] value in
                placeholderLabel.isHidden = !(value.text?.isEmpty ?? true)
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UITextView.textDidEndEditingNotification, object: textView)
            .compactMap { $0.object as? UITextView }
            .sink { [unowned self] text in
                resetState()
            }
            .store(in: &cancellable)
        
        mode
            .sink { [unowned self] mode in
                switch mode {
                case .still: resetState()
                default:
                    closeButton.isHidden = mode.closeButtonHidden
                    activeTextViewConstraint.isActive = !mode.closeButtonHidden
                    if mode.active { textView.selectAll(self) }
                }
            }
            .store(in: &cancellable)
        
    }
    
    @objc
    private func handleTapGesture() {
        switch mode.value {
        case .forced(let isOpen):
            if !isOpen { mode.value = .forced(isOpen: !isOpen) }
        default:
            if !mode.value.active { mode.value = .opened }
        }
    }
    
    @objc
    private func handleCloseButtonTap() {
        switch mode.value {
        case .forced(let isOpen):
            mode.value = .forced(isOpen: !isOpen)
            resetState()
        default:
            if mode.value.active { mode.value = .still }
            resetState()
        }
        
    }
    
    private func resetState() {
        textView.text = ""
        placeholderLabel.isHidden = false
        textView.resignFirstResponder()
        closeButton.isHidden = mode.value.closeButtonHidden
        activeTextViewConstraint.isActive = !mode.value.closeButtonHidden
    }
    
}

extension MainInputView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textPublisher.send(textView.text)
            return false
        }
        return true
    }
    
}
