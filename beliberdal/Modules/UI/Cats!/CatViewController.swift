//
//  CatViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import UIKit
import Combine

class CatViewController: ViewController<CatView> {
    
    // MARK: - Properties
    
    private let viewModel: CatViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(_ vm: CatViewModelProtocol) {
        self.viewModel = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cats!"
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
    
    private func bind() {
        viewModel.output.image
            .sink { [weak self] image in
                self?.mainView.imageView.image = image
                self?.mainView.fireButton.setState(to: .still)
            }
            .store(in: &cancellable)
        
        viewModel.output.error
            .sink { [weak self] _ in
                self?.handleError()
            }
            .store(in: &cancellable)
        
        mainView.fireButton.addTarget(self, action: #selector(fire), for: .touchUpInside)
    }
    
    @objc
    private func fire() {
        mainView.fireButton.setState(to: .loading)
        viewModel.input.fireAction.send()
    }
    
    private func handleError() {
        let alert = UIAlertController(title: "Error occured!", message: "Were so sorry.", preferredStyle: .alert)
        alert.addAction(.init(title: "uwu", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

