//
//  FavouritesTableViewCell.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 08.09.2021.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { "FavouritesTableViewCell" }
    
    lazy var bubbleView: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIView())
    
    lazy var transformerNameLabel: UILabel = {
        $0.font = .systemFont(ofSize: 11, weight: .semibold)
        $0.textColor = .fontBlack
        $0.text = "Balaboba"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UILabel())
    
    lazy var contentTextView: UITextView = {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .accentPink
        $0.isEditable = false
        $0.text = "Пиво Пиво пивопивопивопивопивопивопивопивопивопивопиво пиво"
        $0.isScrollEnabled = false
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UITextView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        backgroundColor = .clear
        
        contentView.addSubview(bubbleView)
        let bubbleViewBottomConstraint = bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        bubbleViewBottomConstraint.priority = .init(rawValue: 749)
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bubbleViewBottomConstraint,
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        bubbleView.addSubview(transformerNameLabel)
        NSLayoutConstraint.activate([
            transformerNameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            transformerNameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16)
        ])
        
        bubbleView.addSubview(contentTextView)
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: transformerNameLabel.leadingAnchor),
            contentTextView.topAnchor.constraint(equalTo: transformerNameLabel.bottomAnchor, constant: 5),
            contentTextView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -16),
            contentTextView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with item: TransformerResultDTO) {
        transformerNameLabel.text = item.transformerName
        contentTextView.text = item.content
    }
    
}
