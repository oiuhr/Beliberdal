//
//  MainViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit
import Combine

class MainViewController: ViewController<MainView> {
    
    private let transformer: StringTransformerProtocol = BeliberdalService()
    private let settingsService = SettingsService.shared
    
    private lazy var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.switchModeButton.addTarget(self, action: #selector(mode), for: .touchUpInside)
        mainView.fireButton.addTarget(self, action: #selector(fire), for: .touchUpInside)
        
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
        settingsService.strategy
            .sink { [unowned self] value in
                mainView.switchModeButton.setTitle(value.description, for: .normal)
            }
            .store(in: &cancellable)
    }
    
    @objc
    func fire() {
        guard let text = mainView.contentView.inputTextView.text else { return }
        transformer.transform(text)
            .breakpointOnError()
            .receive(on: RunLoop.main)
            .sink { _ in } receiveValue: { [weak self] value in
                self?.mainView.contentView.outputTextView.text = value
            }
            .store(in: &cancellable)
    }
    
    @objc
    func mode() {
        switch settingsService.strategy.value {
        case .mock:
            settingsService.setStrategy(.balaboba)
        case .balaboba:
            settingsService.setStrategy(.mock)
        }
    }
    
}
