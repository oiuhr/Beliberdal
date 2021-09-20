//
//  SettingsStorageProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 20.09.2021.
//

import Foundation

protocol SettingsStorageProtocol: AnyObject {
    var strategy: StringTransformerType { get set }
}
