//
//  SettingsServiceMock.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 16.09.2021.
//

import Foundation
import Combine

@testable import beliberdal

class SettingsServiceMock: SettingsServiceProtocol {
    
    var _strategy = CurrentValueSubject<StringTransformerType, Never>(.smiley(mode: .happy))
    var strategy: AnyPublisher<StringTransformerType, Never>
    
    var tryedToSwitchMode: Bool = false
    
    init() {
        strategy = _strategy.eraseToAnyPublisher()
    }
    
    func setStrategy(_ strategy: StringTransformerType) {
        tryedToSwitchMode = true
        _strategy.send(strategy)
    }
    
}
