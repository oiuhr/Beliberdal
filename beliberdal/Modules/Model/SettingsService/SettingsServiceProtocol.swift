//
//  SettingsServiceProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Combine

protocol SettingsServiceProtocol: AnyObject {
    var strategy: AnyPublisher<StringTransformerType, Never> { get }
    func setStrategy(_ strategy: StringTransformerType)
}
