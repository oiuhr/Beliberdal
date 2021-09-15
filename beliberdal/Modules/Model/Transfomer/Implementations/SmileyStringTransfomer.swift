//
//  SmileyStringTransfomer.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Combine
import Foundation

final class SmileyStringTransformer: StringTransformerProtocol {
    
    static var name: String { "Смайлики" }
    
    var currentMode: Modes
    
    init(for mode: Modes) {
        self.currentMode = mode
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        return Just("\(string) \(currentMode.smiley)")
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

extension SmileyStringTransformer {
    
    enum Modes: Int, CaseIterable, Codable {
        case happy
        case sad
        
        var modeDescription: String {
            switch self {
            case .happy: return "Улыбчивый смайлик"
            case .sad: return "Грустный смайлик"
            }
        }
        
        var smiley: String {
            switch self {
            case .happy: return ":)"
            case .sad: return ":("
            }
        }
    }
    
}
