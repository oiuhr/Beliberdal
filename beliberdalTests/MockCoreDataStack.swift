//
//  MockCoreDataStack.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import CoreData

class MockCoreDataStack: CoreDataStack {
    
    override init(modelName: String) {
//        super.init(modelName: modelName)
        super.init(modelName: modelName)
        
//        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
//        let model = NSManagedObjectModel(contentsOf: modelURL)!
//
//        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
//        let persistentStoreDescription = NSPersistentStoreDescription()
//        persistentStoreDescription.type = NSInMemoryStoreType
//        container.persistentStoreDescriptions = [persistentStoreDescription]
//
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("\(error)")
//            }
//        }
        
    }
    
}
