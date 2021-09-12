//
//  SettingsStorage.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 12.09.2021.
//

import Foundation

protocol SettingsStorageProtocol: AnyObject {
    var strategy: StringTransformerType { get set }
}

class SettingsStorage: SettingsStorageProtocol {
    private static var strategyDefaultsKey: String { "currentStrategy" }
    
    @CodableDefaults(strategyDefaultsKey, defaultValue: StringTransformerType.smiley(mode: .happy))
    var strategy: StringTransformerType
}
