//
//  MainViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit
import Combine

class MainViewController: ViewController<MainView> {
    
    // MARK: - Properties
    
    private let viewModel: MainViewModelProtocol
    private lazy var cancellable = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(_ vm: MainViewModelProtocol) {
        self.viewModel = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let tabBar = tabBarController else { return }
        tabBar.tabBar.backgroundImage = UIImage()
        tabBar.tabBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tabBar = tabBarController else { return }
        tabBar.tabBar.backgroundImage = nil
        tabBar.tabBar.shadowImage = nil
    }
    
    // MARK: - Methods
    
    private func bind() {
        viewModel.output.currentTransformerMode
            .sink { [unowned self] value in
                mainView.switchModeButton.setTitle(value, for: .normal)
            }
            .store(in: &cancellable)
        
        viewModel.output.transformResult
            .sink { [unowned self] _ in handleError() } receiveValue: { [unowned self] value in
                mainView.contentView.outputTextView.text = value
            }
            .store(in: &cancellable)
        
        mainView.switchModeButton.addTarget(self, action: #selector(mode), for: .touchUpInside)
        mainView.fireButton.addTarget(self, action: #selector(fire), for: .touchUpInside)
        mainView.contentView.favouriteButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        mainView.contentView.catsButton.addTarget(self, action: #selector(openCats), for: .touchUpInside)
    }
    
    @objc
    private func fire() {
        guard let text = mainView.contentView.inputTextView.text else { return }
        viewModel.input.transformAction.send(text)
    }
    
    @objc
    private func mode() {
        viewModel.input.needsModeChange.send()
    }
    
    @objc
    private func openCats() {
        viewModel.input.openCatsAction.send()
    }
    
    @objc
    private func save() {
        viewModel.input.addToFavouritesAction.send()
    }
    
    private func handleError() {
        let alert = UIAlertController(title: "Error occured!", message: "Were so sorry.", preferredStyle: .alert)
        alert.addAction(.init(title: "uwu", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
