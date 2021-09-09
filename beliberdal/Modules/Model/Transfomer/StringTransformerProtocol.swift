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

enum StringTransformerType: CaseIterable {
    
    /// Yandex Balaboba wrapper.
    case balaboba(mode: BalabobaStringTransformer.Modes)
    
    /// Mock used for testing purposes.
    case smiley(mode: SmileyStringTransformer.Modes)

    /// Entity for case.
    var entity: StringTransformerProtocol {
        switch self {
        case .balaboba(let mode): return BalabobaStringTransformer(for: mode)
        case .smiley(let mode): return SmileyStringTransformer(for: mode)
        }
    }
    
    var modeName: String {
        switch self {
        case .balaboba(let mode): return mode.modeDescription
        case .smiley(let mode): return mode.modeDescription
        }
    }
    
    /// Display name for case.
    var name: String {
        switch self {
        case .balaboba: return BalabobaStringTransformer.name
        case .smiley: return SmileyStringTransformer.name
        }
    }
    
    static var allCases: [StringTransformerType] {
        [
            .balaboba(mode: .none),
            .balaboba(mode: .advertisingSlogans),
            .balaboba(mode: .conspiracyTheories),
            .smiley(mode: .happy),
            .smiley(mode: .sad)
        ]
    }
    
}

extension StringTransformerType: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(self.name) }
    static func == (lhs: StringTransformerType, rhs: StringTransformerType) -> Bool {
        switch (lhs, rhs) {
        case (.balaboba(let lm), .balaboba(let rm)):
            return lm == rm
        case (.smiley(let lm), .smiley(let rm)):
            return lm == rm
        default: return false
        }
    }
}

