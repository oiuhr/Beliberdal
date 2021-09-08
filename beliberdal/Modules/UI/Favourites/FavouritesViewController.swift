//
//  FavouritesViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 08.09.2021.
//

import UIKit

class FavouritesViewController: ViewController<FavouritesView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func setupUI() {
        title = "Favourites"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.reuseIdentifier, for: indexPath) as? FavouritesTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    
    
}
