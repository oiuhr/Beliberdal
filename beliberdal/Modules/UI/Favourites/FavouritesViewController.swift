//
//  FavouritesViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 08.09.2021.
//

import UIKit
import Combine

class FavouritesViewController: ViewController<FavouritesView> {
    
    // MARK: - Properties
    
    typealias DataSource = FavouritesDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TransformerResultDTO>
    
    private lazy var dataSource: DataSource = createDataSource()
    private let viewModel: FavouritesViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Lyfecycle
    
    init(_ vm: FavouritesViewModelProtocol) {
        self.viewModel = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        title = "Favourites"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = dataSource
    }
    
    // workaround for
    // https://www.google.com/search?sxsrf=AOaemvLcgMH0BAQpFwm8bkFq-hmIscJ5Hg:1631542526126&q=Warning+once+only:+UITableView+was+told+to+layout+its+visible+cells+and+other+contents+without+being+in+the+view+hierarchy+(the+table+view+or+one+of+its+superviews+has+not+been+added+to+a+window)+diffable+data+source&spell=1&sa=X&ved=2ahUKEwig_9HFkfzyAhUjlosKHddHD9AQBSgAegQIARA1&biw=1680&bih=971
    private var firstLoad: Bool = true
    private func bind() {
        viewModel.output.items
            .sink { [weak self] items in
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(items, toSection: .main)
                self?.dataSource.apply(snapshot, animatingDifferences: !(self?.firstLoad ?? true))
                self?.firstLoad = false
            }
            .store(in: &cancellable)
        
        viewModel.output.items
            .map { $0.isEmpty }
            .sink { [weak self] isEmpty in
                self?.mainView.placeholderView.isHidden = !isEmpty
            }
            .store(in: &cancellable)
        
        dataSource.deleteAction
            .sink { [weak self] item in
                self?.viewModel.input.deleteAction.send(item)
            }
            .store(in: &cancellable)
    }
    
}

// MARK: – UITableViewDataSource

extension FavouritesViewController {
    
    enum Section {
        case main
    }
    
    // ds subclass to achieve swipe to delete behaviour
    class FavouritesDataSource: UITableViewDiffableDataSource<Section, TransformerResultDTO> {
        // publisher for delete action
        let deleteAction = PassthroughSubject<TransformerResultDTO, Never>()
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle {
            case .delete:
                if let item = self.itemIdentifier(for: indexPath) { deleteAction.send(item) }
            default: break
            }
        }
    }
    
    private func createDataSource() -> DataSource {
        DataSource(tableView: mainView.tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.reuseIdentifier, for: indexPath) as? FavouritesTableViewCell
            cell?.configure(with: itemIdentifier)
            
            return cell
        }
    }
    
}

// MARK: – UITableViewDelegate

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

