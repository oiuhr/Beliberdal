//
//  StringTransformerType.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 09.09.2021.
//

import Foundation

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
            .balaboba(mode: .horoscopes),
            .balaboba(mode: .wikiInShort),
            .balaboba(mode: .shortStories),
            .balaboba(mode: .folkWisdom),
            .balaboba(mode: .quotes),
            .balaboba(mode: .instagramCaptions),
            .balaboba(mode: .advertisingSlogans),
            .balaboba(mode: .movieSynopsis),
            .balaboba(mode: .toasts),
            .balaboba(mode: .tvReports),
            .balaboba(mode: .conspiracyTheories),
            
            .smiley(mode: .sad),
            .smiley(mode: .happy)
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

extension StringTransformerType: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case balaboba
        case smiley
    }
    
    enum StringTransformerTypeCodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? values.decode(BalabobaStringTransformer.Modes.self, forKey: .balaboba) {
            self = .balaboba(mode: value)
            return
        }
        if let value = try? values.decode(SmileyStringTransformer.Modes.self, forKey: .smiley) {
            self = .smiley(mode: value)
            return
        }
        throw StringTransformerTypeCodingError.decoding("\(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .balaboba(let mode):
            try container.encode(mode, forKey: .balaboba)
        case .smiley(let mode):
            try container.encode(mode, forKey: .smiley)
        }
    }
    
}
