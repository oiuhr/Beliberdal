//
//  SettingsService.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Combine

final class SettingsService: SettingsServiceProtocol {
    
    private let _strategy: CurrentValueSubject<StringTransformerType, Never>
    private let storage: SettingsStorageProtocol
    
    let strategy: AnyPublisher<StringTransformerType, Never>
    
    init(_ storage: SettingsStorageProtocol) {
        self.storage = storage
        self._strategy = CurrentValueSubject<StringTransformerType, Never>(storage.strategy)
        self.strategy = self._strategy.eraseToAnyPublisher()
    }

    func setStrategy(_ strategy: StringTransformerType) {
        storage.strategy = strategy
        _strategy.send(strategy)
    }
    
}

protocol SettingsStorageProtocol: AnyObject {
    var strategy: StringTransformerType { get set }
}

class SettingsStorage: SettingsStorageProtocol {
    private static var strategyDefaultsKey: String { "currentStrategy" }
    
    @CodableDefaults(strategyDefaultsKey, defaultValue: StringTransformerType.smiley(mode: .happy))
    var strategy: StringTransformerType
}

