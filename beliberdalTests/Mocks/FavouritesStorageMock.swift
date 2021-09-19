//
//  FavouritesStorageMock.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 16.09.2021.
//

import Foundation
import Combine

@testable import beliberdal

class FavouritesStorageMock: FavouritesStorageProtocol {
    
    var tryedToSave: Bool = false
    var tryedToDelete: Bool = false
    
    func save(_ item: TransformerResultDTO) {
        tryedToSave = true
    }
    
    func delete(_ item: TransformerResultDTO) {
        tryedToDelete = true
    }
    
    func contains(_ item: TransformerResultDTO) -> Bool {
        false
    }
    
    init() {
        itemsPublisher = _items.eraseToAnyPublisher()
    }
    
    var _items = CurrentValueSubject<[TransformerResultDTO], Never>([])
    var itemsPublisher: AnyPublisher<[TransformerResultDTO], Never>
    
    
}
