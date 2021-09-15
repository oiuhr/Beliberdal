//
//  CoreDataStack.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 13.09.2021.
//

import Foundation
import CoreData

class CoreDataStack {

    var container: NSPersistentContainer

    init(modelName: String) {
        let container = NSPersistentContainer(name: modelName)
        self.container = container
        
        container.loadPersistentStores { desc, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
    var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
}

