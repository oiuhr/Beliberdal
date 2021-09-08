//
//  SettingsView.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 01.09.2021.
//

import UIKit

class SettingsView: UIView {
    
    static var cellReuseIdentifier: String { "SettingsViewTableViewCell" }
    static var headerReuseIdentifier: String { "SettingsViewTableViewHeader" }
    
    lazy var tableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: SettingsView.cellReuseIdentifier)
        $0.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: SettingsView.headerReuseIdentifier)
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    } (UITableView(frame: .zero, style: .insetGrouped))
    
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
    }
    
}
