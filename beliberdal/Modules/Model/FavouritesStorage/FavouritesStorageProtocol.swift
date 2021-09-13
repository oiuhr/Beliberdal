//
//  FavouritesStorageProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 13.09.2021.
//

import Foundation
import Combine

protocol FavouritesStorageProtocol {
    func save(_ item: TransformerResultDTO)
    func delete(_ item: TransformerResultDTO)
    func contains(_ item: TransformerResultDTO) -> Bool
    var itemsPublisher: AnyPublisher<[TransformerResultDTO], Never> { get }
}
