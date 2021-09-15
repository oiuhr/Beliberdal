//
//  FireButton.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import UIKit
import Combine

class FireButton: RoundedButton {
    
    enum State {
        case loading
        case still
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        $0.style = .medium
        $0.color = .white
        $0.hidesWhenStopped = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    } (UIActivityIndicatorView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalTo: widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: heightAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        if let iv = self.imageView {
            iv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iv.widthAnchor.constraint(equalTo: widthAnchor),
                iv.heightAnchor.constraint(equalTo: heightAnchor)
            ])
        }
    }
    
    func setState(to mode: State) {
        switch mode {
        case .still:
            activityIndicator.stopAnimating()
            setImage(lastImage, for: .normal)
        case .loading:
            activityIndicator.startAnimating()
            setImage(nil, for: .normal)
        }
    }
    
    private var lastImage: UIImage?
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        if image == nil { super.setImage(.init(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate),
                                        for: .normal); return }
        super.setImage(image, for: state)
        lastImage = image
    }
    
}
