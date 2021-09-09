//
//  SettingsViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 01.09.2021.
//

import UIKit
import Combine

final class SettingsViewController: ViewController<SettingsView> {
    
    // MARK: - Properties
    
    typealias DataSource = UITableViewDiffableDataSource<String, StringTransformerType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, StringTransformerType>
    private lazy var dataSource: DataSource = createDataSource()
    
    /// https://developer.apple.com/documentation/uikit/uitableviewdelegate/handling_row_selection_in_a_table_view
    private var lastlySelectedCell: UITableViewCell?
    
    private let viewModel: SettingsViewModelProtocol
    private lazy var cancellable = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(_ vm: SettingsViewModelProtocol) {
        self.viewModel = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(SettingsViewModel(SettingsService.shared))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        title = "Settings"
        mainView.tableView.delegate = self
    }
    
    private func bind() {
        viewModel.output.optionList
            .sink { [weak self] options in
                var dict: [String : [StringTransformerType]] = [:]
                for option in options {
                    if let value = dict[option.name] {
                        dict[option.name] = value + [option]
                    } else { dict[option.name] = [option] }
                }
        
                var snapshot = Snapshot()
                for option in dict.sorted(by: { $0.key < $1.key }) {
                    snapshot.appendSections([option.key])
                    snapshot.appendItems(option.value, toSection: option.key)
                }
                
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellable)
    }
    
}

// MARK: - UITableViewDataSource

extension SettingsViewController {
    
    private func createDataSource() -> DataSource {
        DataSource(tableView: mainView.tableView) { [weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsView.cellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = itemIdentifier.modeName
            cell.textLabel?.font = .systemFont(ofSize: 14)
            cell.tintColor = .accentPink
            
            let selected = itemIdentifier == self?.viewModel.output.currentMode.value
            cell.accessoryType = selected ? .checkmark : .none
            if selected { self?.lastlySelectedCell = cell }
    
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell == lastlySelectedCell { return }
        cell?.accessoryType = .checkmark
        lastlySelectedCell?.accessoryType = .none
        lastlySelectedCell = cell
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.input.switchMode.send(item)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.textColor = .fontBlack
        header.textLabel?.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsView.headerReuseIdentifier)
        let section = dataSource.snapshot().sectionIdentifiers[section]
        view?.textLabel?.text = section
        
        return view
    }
    
}
