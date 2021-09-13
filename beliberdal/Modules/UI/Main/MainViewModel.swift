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
    let addToFavouritesAction: PassthroughSubject<Void, Never>
}

struct MainViewModelOutput {
    let transformResult: AnyPublisher<String, Error>
    let currentTransformerMode: AnyPublisher<String, Never>
}

protocol MainViewModelProtocol {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

class MainViewModel: MainViewModelProtocol {
    
    let input: MainViewModelInput
    let output: MainViewModelOutput
    
    /// navigation
    var openSettings: Action?
    
    /// input
    private let transformAction = PassthroughSubject<String, Never>()
    private let needsModeChange = PassthroughSubject<Void, Never>()
    private let addToFavouritesAction = PassthroughSubject<Void, Never>()
    
    /// output
    private let result = CurrentValueSubject<String, Error>("")
    private let transformerName = CurrentValueSubject<String, Never>("")
    
    /// local
    private let transformer: BeliberdalService
    private let settingsService: SettingsServiceProtocol
    private let favouritesStorage: FavouritesStorageProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(settingsService: SettingsServiceProtocol,
         beliberdalService: BeliberdalService,
         favouritesStorage: FavouritesStorageProtocol) {
        
        self.settingsService = settingsService
        self.transformer = beliberdalService
        self.favouritesStorage = favouritesStorage
        
        input = .init(transformAction: transformAction, needsModeChange: needsModeChange, addToFavouritesAction: addToFavouritesAction)
        output = .init(transformResult: result.eraseToAnyPublisher(), currentTransformerMode: transformerName.eraseToAnyPublisher())
        
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
        
        needsModeChange
            .sink { [weak self] in self?.openSettings?() }
            .store(in: &cancellable)
        
        addToFavouritesAction
            .compactMap { [weak self] _ -> TransformerResultDTO? in
                guard let result = self?.result.value,
                      !result.isEmpty,
                      let transformerName = self?.transformerName.value else { return nil }
                return TransformerResultDTO(id: UUID(),
                                            transformerName: transformerName,
                                            content: result)
            }
            .sink { [weak self] item in
                self?.favouritesStorage.save(item)
            }
            .store(in: &cancellable)
        
        settingsService.strategy
            .sink { [weak self] value in
                self?.transformerName.value = "\(value.name) – \(value.modeName)"
            }
            .store(in: &cancellable)
    }
    
}
