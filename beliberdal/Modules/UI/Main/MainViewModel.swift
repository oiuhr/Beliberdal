//
//  MainViewModel.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 24.08.2021.
//

import Foundation
import Combine

struct MainViewModelInput {
    let transformAction: PassthroughSubject<String, Never>
    let needsModeChange: PassthroughSubject<Void, Never>
}

struct MainViewModelOutput {
    let transformResult: AnyPublisher<String, Error>
    let currentTransformerMode: AnyPublisher<StringTransformerType, Never>
}

class MainViewModel {
    
    let input: MainViewModelInput
    let output: MainViewModelOutput
    
    /// input
    private let transformAction = PassthroughSubject<String, Never>()
    private let needsModeChange = PassthroughSubject<Void, Never>()
    
    /// output
    private let result = CurrentValueSubject<String, Error>("")
    
    /// local
    private let transformer: BeliberdalService
    private let settingsService: SettingsServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(settingsService: SettingsServiceProtocol, beliberdalService: BeliberdalService) {
        
        self.settingsService = settingsService
        self.transformer = beliberdalService
        
        input = .init(transformAction: transformAction, needsModeChange: needsModeChange)
        output = .init(transformResult: result.eraseToAnyPublisher(), currentTransformerMode: settingsService.strategy)
        
        transformAction
            .setFailureType(to: Error.self)
            .map { [unowned self] string in
                transformer.transform(string)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error): result.send(completion: .failure(error))
                default: print(completion)
                }
            } receiveValue: { [unowned self] transformed in
                print(transformed)
                result.send(transformed)
            }
            .store(in: &cancellable)
    }
    
}
