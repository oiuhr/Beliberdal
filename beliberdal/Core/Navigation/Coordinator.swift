//
//  Coordinator.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 12.09.2021.
//

import UIKit

typealias Action = (() -> Void)

protocol Coordinator {
    func start()
    var toPresent: UIViewController { get }
}

class MainCoordinator: Coordinator {
    
    private let navigationController: UINavigationController = .init()
    var toPresent: UIViewController {
        navigationController
    }
    
    private let settingsService: SettingsServiceProtocol
    private let beliberdalService: BeliberdalService
    private let favouritesStorage: FavouritesStorageProtocol
    
    init(favouritesStorage: FavouritesStorageProtocol) {
        settingsService = SettingsService(SettingsStorage())
        beliberdalService = BeliberdalService(settingsService: settingsService)
        self.favouritesStorage = favouritesStorage
    }
    
    func start() {
        let vm = MainViewModel(settingsService: settingsService, beliberdalService: beliberdalService)
        vm.openSettings = openSettings
        let vc = MainViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openSettings() {
        let vm = SettingsViewModel(settingsService)
        let vc = SettingsViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
