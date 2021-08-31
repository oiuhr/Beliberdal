//
//  MainViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit
import Combine

class MainViewController: ViewController<MainView> {
    
    private let viewModel = MainViewModel()
    private lazy var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let tabBar = tabBarController else { return }
        tabBar.tabBar.backgroundImage = UIImage()
        tabBar.tabBar.shadowImage = UIImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let tabBar = tabBarController else { return }
        tabBar.tabBar.backgroundImage = nil
        tabBar.tabBar.shadowImage = nil
    }
    
    private func bind() {
        viewModel.output.currentTransformerMode
            .sink { [unowned self] value in
                mainView.switchModeButton.setTitle(value.description, for: .normal)
            }
            .store(in: &cancellable)
        
        viewModel.output.transformResult
//            .catch { _ in handleError() }
            .sink { [unowned self] _ in handleError() } receiveValue: { [unowned self] value in
                mainView.contentView.outputTextView.text = value
            }
            .store(in: &cancellable)
        
        mainView.switchModeButton.addTarget(self, action: #selector(mode), for: .touchUpInside)
        mainView.fireButton.addTarget(self, action: #selector(fire), for: .touchUpInside)
    }
    
    @objc
    private func fire() {
        guard let text = mainView.contentView.inputTextView.text else { return }
        viewModel.input.transformAction.send(text)
    }
    
    @objc
    private func mode() {
        viewModel.input.needsModeChange.send(())
    }
    
    private func handleError() {
        let alert = UIAlertController(title: "Error occured!", message: "Were so sorry.", preferredStyle: .alert)
        alert.addAction(.init(title: "uwu", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
