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

protocol StringTransfomerOption {
    var modeDescription: String { get }
}

/// Protocol for any entity that could transform given string.
protocol StringTransformerProtocol: AnyObject {
    /// Transforms given string to any nonsense.
    static var name: String { get }
    func transform(_ string: String) -> AnyPublisher<String, Error>
}

enum StringTransformerType: CaseIterable {
    
    /// Yandex Balaboba wrapper.
    case balaboba(mode: BalabobaStringTransformer.Modes)
    
    /// Mock used for testing purposes.
    case smiley(mode: SmileyStringTransformer.Modes)

    /// Helper computed variable to init class from enum value.
    var entity: StringTransformerProtocol {
        switch self {
        case .balaboba(let mode): return BalabobaStringTransformer(for: mode)
        case .smiley(let mode): return SmileyStringTransformer(for: mode)
        }
    }
    
    var availableModes: [String] {
        switch self {
        case .balaboba: return BalabobaStringTransformer.Modes.allCases.map { $0.modeDescription }
        case .smiley: return SmileyStringTransformer.Modes.allCases.map { $0.modeDescription }
        }
    }
    
    /// Name for case.
    var name: String {
        switch self {
        case .balaboba: return BalabobaStringTransformer.name
        case .smiley: return SmileyStringTransformer.name
        }
    }
    
    static var allCases: [StringTransformerType] {
        [.balaboba(mode: .none), .smiley(mode: .happy)]
    }
}
