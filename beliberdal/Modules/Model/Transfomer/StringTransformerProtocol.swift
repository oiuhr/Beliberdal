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
//    var rawValue: Int { get }
    var modeDescription: String { get }
//    var allCases: [StringTransfomerOption] { get }
}

/// Protocol for any entity that could transform given string.
protocol StringTransformerProtocol: AnyObject {
    /// Transformer display name.
    static var name: String { get }
    /// Transforms given string to any nonsense.
    func transform(_ string: String) -> AnyPublisher<String, Error>
}

protocol OptionedStringTransformedProtocol: StringTransformerProtocol {
    associatedtype Mode = RawRepresentable & CaseIterable & StringTransfomerOption
    var currentMode: Mode { get }
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
    
    var availableModes: [StringTransformerType] {
        switch self {
        case .balaboba: return BalabobaStringTransformer.Modes.allCases.enumerated()
                .map { StringTransformerType.balaboba(mode: .init(rawValue: $0.offset) ?? .none) }
        case .smiley: return SmileyStringTransformer.Modes.allCases.enumerated()
                .map { StringTransformerType.smiley(mode: .init(rawValue: $0.offset) ?? .happy) }
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
        [.balaboba(mode: .none), .smiley(mode: .happy)]
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

