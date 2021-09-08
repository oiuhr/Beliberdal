//
//  SettingsViewModel.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 08.09.2021.
//

import Combine

struct SettingsViewModelInput {
    let switchMode: PassthroughSubject<StringTransformerType, Never>
}

struct SettingsViewModelOutput {
    var currentMode: CurrentValueSubject<StringTransformerType, Never>
    var optionList: AnyPublisher<[StringTransformerType], Never>
}

protocol SettingsViewModelProtocol {
    var input: SettingsViewModelInput { get }
    var output: SettingsViewModelOutput { get }
}

final class SettingsViewModel: SettingsViewModelProtocol {
    
    let input: SettingsViewModelInput
    let output: SettingsViewModelOutput
    
    /// input
    private let switchMode = PassthroughSubject<StringTransformerType, Never>()
    
    /// output
    private let currentMode = CurrentValueSubject<StringTransformerType, Never>(.balaboba(mode: .none))
    private let optionList = CurrentValueSubject<[StringTransformerType], Never>(StringTransformerType.allCases)
    
    /// local
    private let settingsService: SettingsServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(_ settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
        
        input = .init(switchMode: switchMode)
        output = .init(currentMode: currentMode, optionList: optionList.eraseToAnyPublisher())
        
        settingsService.strategy
            .sink { [weak self] value in
                self?.currentMode.value = value
            }
            .store(in: &cancellable)
        
        switchMode
            .sink { [weak self] mode in
                self?.settingsService.setStrategy(mode)
            }
            .store(in: &cancellable)
    }
    
}
