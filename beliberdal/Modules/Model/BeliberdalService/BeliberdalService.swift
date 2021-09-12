//
//  BeliberdalService.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Combine

// strategy container
final class BeliberdalService {
    
    static var name: String { "belib" }
    
    private var strategy: StringTransformerProtocol?
    private let settings: SettingsServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(settingsService: SettingsServiceProtocol) {
        self.settings = settingsService
        bind()
    }
    
    private func bind() {
        settings.strategy
            .sink { [weak self] mode in
                self?.strategy = mode.entity
                print(mode, self?.strategy as Any)
            }
            .store(in: &cancellable)
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        strategy?.transform(string) ?? Fail<String, Error>
            .init(error: StringTransformerError.undefined)
            .eraseToAnyPublisher()
    }
    
}
