//
//  StringTransformerProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import Combine
import Foundation
import UIKit

enum StringTransformerError: Error {
    case undefined
}

/// Protocol for any entity that could transform given string.
protocol StringTransformerProtocol: AnyObject {
    /// Transformer display name.
    static var name: String { get }
    /// Transforms given string to any nonsense.
    func transform(_ string: String) -> AnyPublisher<String, Error>
}
