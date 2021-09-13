//
//  PlaceholderView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 13.09.2021.
//

import UIKit

class PlaceholderView: UIView {
    
    let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UIImageView())
    
    let primaryLabel: UILabel = {
        $0.font = .systemFont(ofSize: 24, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UILabel())
    
    let secondaryLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .accentPink
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    } (UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        backgroundColor = .clear
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 56),
            imageView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        addSubview(primaryLabel)
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(secondaryLabel)
        NSLayoutConstraint.activate([
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 15),
            secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: primaryLabel.trailingAnchor),
            secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    enum PlaceholderModes {
        case noFavourites
        
        var primaryText: String {
            switch self {
            case .noFavourites:
                return "No Favourites"
            }
        }
        
        var secondaryText: String {
            switch self {
            case .noFavourites:
                return "Your favourite rubbish will appear here."
            }
        }
        
        var image: UIImage? {
            switch self {
            case .noFavourites:
                return UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    func configure(for mode: PlaceholderModes) {
        primaryLabel.text = mode.primaryText
        secondaryLabel.text = mode.secondaryText
        imageView.image = mode.image
    }
    
}

