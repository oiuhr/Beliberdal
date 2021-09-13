//
//  FavouritesViewModel.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 13.09.2021.
//

import Foundation
import Combine

struct FavouritesViewModelInput {
    let deleteAction: PassthroughSubject<TransformerResultDTO, Never>
}

struct FavouritesViewModelOutput {
    let items: AnyPublisher<[TransformerResultDTO], Never>
}

protocol FavouritesViewModelProtocol {
    var input: FavouritesViewModelInput { get }
    var output: FavouritesViewModelOutput { get }
}

class FavouritesViewModel: FavouritesViewModelProtocol {
    
    let input: FavouritesViewModelInput
    let output: FavouritesViewModelOutput
    
    /// input
    private let deleteAction: PassthroughSubject<TransformerResultDTO, Never> = .init()
    
    /// output
    private let items: CurrentValueSubject<[TransformerResultDTO], Never> = .init([])
    
    /// local
    private var cancellable = Set<AnyCancellable>()
    private let storage: FavouritesStorageProtocol
    
    init(favouritesStorage: FavouritesStorageProtocol) {
        self.storage = favouritesStorage
        
        self.input = .init(deleteAction: deleteAction)
        self.output = .init(items: items.eraseToAnyPublisher())
        
        storage.itemsPublisher
            .sink { [weak self] items in
                self?.items.send(items)
            }
            .store(in: &cancellable)
        
        deleteAction
            .sink { [weak self] item in
                self?.storage.delete(item)
            }
            .store(in: &cancellable)
    }
    
}
