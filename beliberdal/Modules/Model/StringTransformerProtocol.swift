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
    /// Transforms given string to any nonsense.
    func transform(_ string: String) -> AnyPublisher<String, Error>
}

protocol VersatileStringTransformerProtocol: StringTransformerProtocol {
    
    typealias ModeIdentifier = UInt
    typealias ModeDescription = String
    typealias ModeList = [ModeIdentifier : ModeDescription]
    
    /// List of modes that could be applyed to transformer.
    /// Built on top of Balaboba API, which accepts "intro" as a parameter that represents the style of the output text.
    var modeList: ModeList { get }
    
    /// Set current mode.
    func setMode(_ mode: ModeIdentifier)
    var currentMode: ModeIdentifier { get }
}

//class BasicTransform: StringTransformerProtocol {
//
//    private(set) var settings: TransformSettings
//
//    init(_ settings: TransformSettings) {
//        self.settings = settings
//    }
//
//    func transform(_ string: String) -> AnyPublisher<String, Error> {
//        switch settings.type {
//        case .mock:
//            return settings.type.entity.transform(string)
//        case .balaboba(let mode):
//            return settings.type.entity.transform(string)
//        }
//    }
//
//}

class StringTransfomerMock: StringTransformerProtocol {
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        Just(string + " :)")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

class SmileyStringTransformer: VersatileStringTransformerProtocol {
    
    private(set) var modeList: ModeList = [
        0: ":)",
        1: ":("
    ]
    private(set) var currentMode: ModeIdentifier = 0
    
    enum Mode {
        case happy
        case unhappy
    }
    
    func setMode(_ mode: ModeIdentifier) {
        currentMode = mode
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        let smiley = modeList[currentMode] ?? ":|"
        return Just("\(string) \(smiley)")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

class BalabobaStringTransformer: VersatileStringTransformerProtocol {
    
    private let networkClient = NetworkClient()
    
    private(set) var modeList: ModeList = [
        0: "Без стиля",
        1: "Теории заговора",
        2: "ТВ-репортажи"
    ]
    private(set) var currentMode: UInt = 0
    
    func setMode(_ mode: ModeIdentifier) {
        currentMode = mode
    }
    
    init(_ mode: ModeIdentifier) {
        setMode(mode)
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        let body = BalabobaEndpoint.Body(query: string, intro: Int(currentMode))
        let request = jsonPostRequest(endpoint: BalabobaEndpoint.endpoint, jsonBody: body)
        
        return networkClient.perform(request)
            .decode(type: BalabobaEndpoint.Response.self, decoder: JSONDecoder())
            .map { "\($0.query + $0.text)" }
            .eraseToAnyPublisher()
    }
    
}

extension BalabobaStringTransformer {
    
    struct BalabobaEndpoint {
        
        static var endpoint = "https://zeapi.yandex.net/lab/api/yalm/text3"
        
        struct Body: Encodable {
            let query: String
            let intro: Int
            let filter: Int = 1
        }
        
        struct Response: Decodable {
            let bad_query: Int
            let error: Int
            let query: String
            let text: String
        }
        
    }
    
}

//class TransformSettings {
//
//    private(set) var type: StringTransformerType
//    private(set) var resolver: StringTransformerProtocol
//
//    init() {
//
//    }
//
//}

enum StringTransformerType {
    /**
     Yandex Balaboba wrapper.
     Could be extended with its styles; currently unsupported
     - note: TODO – balaboba(mode: Int)
     */
    case balaboba(mode: UInt)
    
    /// Mock used for testing purposes.
    case mock
    
    /// Helper computed variable to init class from enum value.
    var entity: StringTransformerProtocol {
        switch self {
        case .balaboba(let value): return BalabobaStringTransformer(value)
        case .mock: return StringTransfomerMock()
        }
    }
    
    /// Description for case.
    var description: String {
        switch self {
        case .balaboba: return "Balaboba"
        case .mock: return "Smiley face"
        }
    }
}

class BeliberdalService: StringTransformerProtocol {
    
    private var strategy: StringTransformerProtocol?
    private let settings: SettingsServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(settingsService: SettingsServiceProtocol) {
        self.settings = settingsService
        bind()
    }
    
    convenience init() {
        self.init(settingsService: SettingsService.shared)
    }
    
    private func bind() {
        settings.strategy
        //            .dropFirst()
            .sink { [weak self] mode in
                self?.strategy = mode.entity
                print(mode, self?.strategy as Any)
            }
            .store(in: &cancellable)
    }
    
//    func perform(_ mode: )
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        strategy?.transform(string) ?? Fail<String, Error>
            .init(error: StringTransformerError.undefined)
            .eraseToAnyPublisher()
    }
    
}

protocol SettingsServiceProtocol {
    var strategy: AnyPublisher<StringTransformerType, Never> { get }
    func setStrategy(_ strategy: StringTransformerType)
}

final class SettingsService: SettingsServiceProtocol {
    // MARK: TODO - Change _strategy visibility to private
    let _strategy: CurrentValueSubject<StringTransformerType, Never> = .init(.mock)
    let strategy: AnyPublisher<StringTransformerType, Never>
    private var cancellable = Set<AnyCancellable>()
    
    static let shared = SettingsService()
    
    init(_ strategy: StringTransformerType) {
        self._strategy.send(strategy)
        self.strategy = _strategy.eraseToAnyPublisher()
    }
    
    convenience init() {
        self.init(.mock)
    }
    
    func setStrategy(_ strategy: StringTransformerType) {
        self._strategy.value = strategy
    }
}
