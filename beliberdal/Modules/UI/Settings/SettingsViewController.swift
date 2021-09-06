//
//  SettingsViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 01.09.2021.
//

import UIKit
import Combine

class SettingsViewController: ViewController<SettingsView> {
    
    private lazy var cancellable = Set<AnyCancellable>()
    let settingsService = SettingsService.shared

    struct HeaderItem: Hashable {
        let title: String
        let items: [SectionListItem]
        static func == (lhs: SettingsViewController.HeaderItem, rhs: SettingsViewController.HeaderItem) -> Bool { lhs.title == rhs.title }
        func hash(into hasher: inout Hasher) { hasher.combine(title) }
    }
    
    struct SectionListItem: Hashable {
        let title: String
        static func == (lhs: SettingsViewController.SectionListItem, rhs: SettingsViewController.SectionListItem) -> Bool { lhs.title == rhs.title }
        func hash(into hasher: inout Hasher) { hasher.combine(title) }
    }
    
    /// https://developer.apple.com/documentation/uikit/uitableviewdelegate/handling_row_selection_in_a_table_view
    private var lastlySelectedCell: UITableViewCell?
    private lazy var dataSource: UITableViewDiffableDataSource<HeaderItem, SectionListItem> = createDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Beliberdal Settings"
        mainView.tableView.delegate = self
        
        
        var snapshot = NSDiffableDataSourceSnapshot<HeaderItem, SectionListItem>()
        for c in StringTransformerType.allCases {
//            snapshot.appendSections([c.description.map {  } ])
        }
        let balabobaItem = HeaderItem(title: "Balaboba", items: [.init(title: "1"), .init(title: "2"), .init(title: "3"), .init(title: "4"), .init(title: "5"),])
        let mockItem = HeaderItem(title: "Smiley", items: [.init(title: ":)"), .init(title: ":(")])
        snapshot.appendSections([balabobaItem, mockItem])
        snapshot.appendItems(balabobaItem.items, toSection: balabobaItem)
        snapshot.appendItems(mockItem.items, toSection: mockItem)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
}

extension SettingsViewController {
    
    private func createDataSource() -> UITableViewDiffableDataSource<HeaderItem, SectionListItem> {
        let ds = UITableViewDiffableDataSource<HeaderItem, SectionListItem>.init(tableView: mainView.tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.title
            cell.accessoryType = cell.isSelected ? .checkmark : .none
            cell.tintColor = .accentPink
            
            return cell
        }
        
        return ds
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        lastlySelectedCell?.accessoryType = .none
        lastlySelectedCell = cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.textColor = .fontBlack
        header.textLabel?.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        view?.textLabel?.text = dataSource.snapshot().sectionIdentifiers[section].title
        
        return view
    }
    
}

extension StringTransformerType: CaseIterable {
    static var allCases: [StringTransformerType] {
        [.balaboba(mode: 0), .mock]
    }
}
