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
    private let favouritesStorage: FavouritesStorageProtocol
    
    init(favouritesStorage: FavouritesStorageProtocol) {
        settingsService = SettingsService(SettingsStorage())
        self.favouritesStorage = favouritesStorage
    }
    
    func start() {
        let vm = MainViewModel(settingsService: settingsService,
                               favouritesStorage: favouritesStorage)
        vm.openSettings = openSettings
        vm.openCats = openCats
        let vc = MainViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openSettings() {
        let vm = SettingsViewModel(settingsService)
        let vc = SettingsViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openCats(query: String) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: sessionConfiguration)
        let networkClient = NetworkClient(session: session)
        let catService = CatService(networkClient: networkClient, requestBuilder: RequestBuilder())
        let vm = CatViewModel(catService: catService, initialPhrase: query)
        let vc = CatViewController(vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
