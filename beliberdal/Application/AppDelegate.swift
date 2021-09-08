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
        
        let vc = UINavigationController(rootViewController: MainViewController())
        vc.isNavigationBarHidden = true
        vc.tabBarItem = .init(title: "Home", image: .init(systemName: "house.fill"), tag: 0)
        let vc2 = UINavigationController(rootViewController: FavouritesViewController())
        vc2.tabBarItem = .init(title: "Favourites", image: .init(systemName: "bookmark.fill"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .accentPink
        tabBarController.viewControllers = [vc, vc2]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "beliberdal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

