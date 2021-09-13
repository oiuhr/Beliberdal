//
//  FavouritesView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 08.09.2021.
//

import UIKit

class FavouritesView: UIView {
    
    lazy var tableView: UITableView = {
        $0.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.reuseIdentifier)
    
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    } (UITableView(frame: .zero, style: .grouped))
    
    lazy var placeholderView: PlaceholderView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.configure(for: .noFavourites)
        return $0
    } (PlaceholderView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fill() {
        backgroundColor = .backgroundLightPink
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalTo: widthAnchor),
            placeholderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
