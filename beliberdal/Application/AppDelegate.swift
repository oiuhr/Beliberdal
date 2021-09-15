//
//  AppDelegate.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 04.07.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startApplication()
        return true
    }
    
    private func startApplication() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UINavigationBar.appearance().tintColor = .accentPink
        
        let storage: FavouritesStorageProtocol = FavouritesStorage(container: CoreDataStack(modelName: "beliberdal"))
    
        let mainCoordinator = MainCoordinator(favouritesStorage: storage)
        mainCoordinator.start()
        let vc = mainCoordinator.toPresent
        vc.tabBarItem = .init(title: "Home", image: .init(systemName: "house.fill"), tag: 0)
        
        let vc2 = UINavigationController(rootViewController: FavouritesViewController(FavouritesViewModel(favouritesStorage: storage)))
        vc2.tabBarItem = .init(title: "Favourites", image: .init(systemName: "bookmark.fill"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .accentPink
        tabBarController.viewControllers = [vc, vc2]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

