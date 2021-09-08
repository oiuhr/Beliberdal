//
//  SettingsService.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Combine

final class SettingsService: SettingsServiceProtocol {
    
    private let _strategy: CurrentValueSubject<StringTransformerType, Never> = .init(.smiley(mode: .happy))
    let strategy: AnyPublisher<StringTransformerType, Never>
    
    private var cancellable = Set<AnyCancellable>()
    
    static let shared = SettingsService()
    
    init(_ strategy: StringTransformerType) {
        self._strategy.send(strategy)
        self.strategy = _strategy.eraseToAnyPublisher()
    }
    
    convenience init() {
        self.init(.smiley(mode: .happy))
    }
    
    func setStrategy(_ strategy: StringTransformerType) {
        self._strategy.value = strategy
    }
}

