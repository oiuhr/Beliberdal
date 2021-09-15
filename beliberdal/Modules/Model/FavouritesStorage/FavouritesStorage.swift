//
//  FavouritesStorage.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 13.09.2021.
//

import Foundation
import Combine
import CoreData

final class FavouritesStorage: FavouritesStorageProtocol {
    
    private let container: CoreDataStack
    let itemsPublisher: AnyPublisher<[TransformerResultDTO], Never>
    private let _items: CurrentValueSubject<[TransformerResultDTO], Never> = .init([])
    
    init(container: CoreDataStack) {
        self.container = container
        self.itemsPublisher = _items.eraseToAnyPublisher()
        
        reload()
    }

    func save(_ item: TransformerResultDTO) {
        let context = container.backgroundContext
        
        context.performAndWait {
            let newItem = TransformerResult(context: context)
            newItem.id = UUID()
            newItem.transformerName = item.transformerName
            newItem.result = item.content
            
            try? context.save()
            reload()
        }
    }
    
    func delete(_ item: TransformerResultDTO) {
        let context = container.backgroundContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransformerResult")
        request.predicate = NSPredicate(format: "id == %@", item.id.uuidString)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        context.performAndWait {
            _ = try? context.execute(deleteRequest)
            try? context.save()
            reload()
        }
    }
    
    func contains(_ item: TransformerResultDTO) -> Bool {
        false
    }
    
    private func reload() {
        let context = container.viewContext
        
        context.performAndWait {
            let request = TransformerResult.fetchRequest()
            let result = try? request.execute()
            guard let safeResult = result else { return }
            let items = safeResult.compactMap { item -> TransformerResultDTO? in
                guard let id = item.id, let name = item.transformerName, let content = item.result else { return nil }
                return TransformerResultDTO(id: id, transformerName: name, content: content)
            }
            self._items.send(items)
        }
    }
    
}
