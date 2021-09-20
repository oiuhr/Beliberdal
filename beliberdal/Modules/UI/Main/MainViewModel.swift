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
    let openSettingsAction: PassthroughSubject<Void, Never>
    let addToFavouritesAction: PassthroughSubject<Void, Never>
    let openCatsAction: PassthroughSubject<Void, Never>
}

struct MainViewModelOutput {
    let currentTransformerMode: AnyPublisher<String, Never>
    let currentMode: AnyPublisher<MainModuleMode, Never>
}

protocol MainViewModelProtocol {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

enum MainModuleMode {
    case empty
    case loading
    case content(initialValue: String, content: String)
    case error(error: Error)
}

typealias Action = (() -> Void)

class MainViewModel: MainViewModelProtocol {
    
    let input: MainViewModelInput
    let output: MainViewModelOutput
    
    /// navigation
    var openSettings: Action?
    var openCats: ((String) -> Void)?
    
    /// input
    private let transformAction = PassthroughSubject<String, Never>()
    private let needsModeChange = PassthroughSubject<Void, Never>()
    private let addToFavouritesAction = PassthroughSubject<Void, Never>()
    private let openCatsAction = PassthroughSubject<Void, Never>()
    
    /// output
    private let transformerName = CurrentValueSubject<String, Never>("")
    private let mode = CurrentValueSubject<MainModuleMode, Never>(.empty)
    
    /// local
    private let transformer: CurrentValueSubject<StringTransformerProtocol, Never> = .init(SmileyStringTransformer(for: .happy))
    private let settingsService: SettingsServiceProtocol
    private let favouritesStorage: FavouritesStorageProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(settingsService: SettingsServiceProtocol,
         favouritesStorage: FavouritesStorageProtocol) {
        
        self.settingsService = settingsService
        self.favouritesStorage = favouritesStorage
    
        input = .init(transformAction: transformAction,
                      openSettingsAction: needsModeChange,
                      addToFavouritesAction: addToFavouritesAction,
                      openCatsAction: openCatsAction)
        output = .init(
            currentTransformerMode: transformerName.eraseToAnyPublisher(),
            currentMode: mode.eraseToAnyPublisher())
        
        bind()
    }
    
    private func bind() {
        transformAction
            .filter { $0.replacingOccurrences(of: " ", with: "") != "" }
            .filter { [weak self] _ in
                if case .loading = self?.mode.value {
                    return false
                }
                return true
            }
            .sink { [weak self] string in
                self?.mode.send(.loading)
                self?.perform(string)
            }
            .store(in: &cancellable)
        
        needsModeChange
            .sink { [weak self] in self?.openSettings?() }
            .store(in: &cancellable)
        
        addToFavouritesAction
            .compactMap { [weak self] _ -> TransformerResultDTO? in
                guard case .content(_, let result) = self?.mode.value,
                      !result.isEmpty,
                      let transformerName = self?.transformerName.value else { return nil }
                return TransformerResultDTO(id: UUID(), transformerName: transformerName, content: result)
            }
            .sink { [weak self] item in
                self?.favouritesStorage.save(item)
            }
            .store(in: &cancellable)

        openCatsAction
            .sink { [weak self] in
                if case .content(let initialValue, _) = self?.mode.value {
                    self?.openCats?(initialValue)
                } else { self?.openCats?("") }
            }
            .store(in: &cancellable)
        
        settingsService.strategy
            .sink { [weak self] value in
                self?.transformerName.value = "\(value.name) – \(value.modeName)"
                self?.transformer.value = value.entity
            }
            .store(in: &cancellable)
    }
    
    private func perform(_ query: String) {
        transformer.value.transform(query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.mode.send(.error(error: error))
                case .finished: break
                }
            } receiveValue: { [weak self] transformed in
                self?.mode.send(.content(initialValue: query, content: transformed))
            }
            .store(in: &cancellable)
        
    }
    
}
