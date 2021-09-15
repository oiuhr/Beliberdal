//
//  MainContentView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 24.08.2021.
//

import UIKit
import Combine

class MainContentView: UIView {
    
    lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentLayoutGuide.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        return $0
    } (UIScrollView())
    
    lazy var inputTitleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 11, weight: .semibold)
        $0.textColor = .fontBlack
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "You say..."
        return $0
    } (UILabel())
    
    lazy var inputTextView: UITextView = {
        $0.text = "Пиво"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .fontBlack
        $0.isScrollEnabled = false
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UITextView())
    
    lazy var separatorLine: UIView = {
        $0.backgroundColor = .hex(0xDCDCDC)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIView())
    
    lazy var outputTitleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 11, weight: .semibold)
        $0.textColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Beliberdal echoes..."
        return $0
    } (UILabel())
    
    lazy var outputTextView: UITextView = {
        $0.accessibilityIdentifier = "output"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .accentPink
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UITextView())
    
    lazy var itemBar: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        $0.effect = blur
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIVisualEffectView())
    
    lazy var favouriteButton: UIButton = {
        $0.setImage(.init(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            $0.imageView!.widthAnchor.constraint(equalToConstant: 26),
            $0.imageView!.heightAnchor.constraint(equalToConstant: 26)
        ])
        return $0
    } (UIButton())
    
    lazy var catsButton: UIButton = {
        $0.setImage(.init(systemName: "leaf.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            $0.imageView!.widthAnchor.constraint(equalToConstant: 26),
            $0.imageView!.heightAnchor.constraint(equalToConstant: 26)
        ])
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
        backgroundColor = .white
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        scrollView.addSubview(inputTitleLabel)
        NSLayoutConstraint.activate([
            inputTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            inputTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
            inputTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)
        ])
        
        scrollView.addSubview(inputTextView)
        NSLayoutConstraint.activate([
            inputTextView.leadingAnchor.constraint(equalTo: inputTitleLabel.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: inputTitleLabel.trailingAnchor),
            inputTextView.topAnchor.constraint(equalTo: inputTitleLabel.bottomAnchor, constant: 3)
        ])
        
        scrollView.addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: inputTextView.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 23),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        scrollView.addSubview(outputTitleLabel)
        NSLayoutConstraint.activate([
            outputTitleLabel.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            outputTitleLabel.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            outputTitleLabel.topAnchor.constraint(equalTo: separatorLine.topAnchor, constant: 23)
        ])
        
        scrollView.addSubview(outputTextView)
        NSLayoutConstraint.activate([
            outputTextView.leadingAnchor.constraint(equalTo: outputTitleLabel.leadingAnchor),
            outputTextView.trailingAnchor.constraint(equalTo: outputTitleLabel.trailingAnchor),
            outputTextView.topAnchor.constraint(equalTo: outputTitleLabel.bottomAnchor, constant: 3),
            outputTextView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -90)
        ])
        
        addSubview(itemBar)
        NSLayoutConstraint.activate([
            itemBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        itemBar.contentView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.leadingAnchor.constraint(equalTo: itemBar.leadingAnchor, constant: 30),
            favouriteButton.centerYAnchor.constraint(equalTo: itemBar.centerYAnchor)
        ])
        
        itemBar.contentView.addSubview(catsButton)
        NSLayoutConstraint.activate([
            catsButton.trailingAnchor.constraint(equalTo: itemBar.trailingAnchor, constant: -30),
            catsButton.centerYAnchor.constraint(equalTo: favouriteButton.centerYAnchor)
        ])
        
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
