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
        
        mainView.button.addTarget(self, action: #selector(fire), for: .touchUpInside)
        mainView.button1.addTarget(self, action: #selector(mode), for: .touchUpInside)
    }
    
    @objc
    func fire() {
        transformer.transform("пиво")
            .breakpointOnError()
            .sink { _ in } receiveValue: { value in
                print(value)
            }
            .store(in: &cancellable)
    }
    
    @objc
    func mode() {
        switch settingsService.strategy.value {
        case .mock: settingsService.setStrategy(.balaboba)
        case .balaboba: settingsService.setStrategy(.mock)
        }
    }
    
}
