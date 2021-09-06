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
    var name: String { get }
    func transform(_ string: String) -> AnyPublisher<String, Error>
}

protocol VersatileStringTransformerProtocol: StringTransformerProtocol {
    
    typealias OptionList = [StringTransformerOptionProtocol]
    
    /// List of modes that could be applyed to transformer.
    /// Built on top of Balaboba API, which accepts "intro" as a parameter that represents the style of the output text.
    var modeList: OptionList { get }
    
    /// Set current mode.
    //    func setMode(_ mode: StringTransformerOptionProtocol)
    var currentMode: StringTransformerOptionProtocol { get }
}

protocol StringTransformerOptionProtocol {
    var id: UInt { get }
    var description: String { get }
    
    typealias Transform = ((String) -> String)
    var transformOperation: Transform? { get }
}

struct StringTransformerOption: StringTransformerOptionProtocol {
    let id: UInt
    let description: String
    var transformOperation: Transform? = nil
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
    
    var name: String {
        "Mock"
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        Just(string + " :)")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

class SmileyStringTransformer: VersatileStringTransformerProtocol {
    
    var name: String {
        "Smiles"
    }
    
    private(set) lazy var modeList: OptionList = [
        StringTransformerOption(id: 0, description: "Смайлик :)", transformOperation: { $0 + " :)" }),
        StringTransformerOption(id: 1, description: "Грустный смайлик :(", transformOperation: { $0 + " :(" }),
        StringTransformerOption(id: 2, description: "none", transformOperation: f(_:))
    ]
    lazy var currentMode: StringTransformerOptionProtocol = modeList[0]
    
    func f(_ string: String) -> String {
        string
    }
    
    init(_ mode: UInt) {
        
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        guard let transformOperation = currentMode.transformOperation else {
            return Fail.init(error: URLError.init(.appTransportSecurityRequiresSecureConnection))
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
        
        return Just(transformOperation(string))
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

class BalabobaStringTransformer: VersatileStringTransformerProtocol {
    
    var name: String {
        "Balaboba"
    }
    
    private let networkClient = NetworkClient()
    
    var currentMode: StringTransformerOptionProtocol = StringTransformerOption(id: 0, description: "")
    var modeList: OptionList = []
    
    static let shared = BalabobaStringTransformer()
    
    private init() {
//        var req = URLRequest(url: .init(string: "https://zeapi.yandex.net/lab/api/yalm/intros")!)
//        req.httpMethod = "GET"
//        let headers = [
//            "Accept": "application/json",
//            "Content-Type": "application/json",
//            "Connection": "keep-alive"
//        ]
//        req.allHTTPHeaderFields = headers
//        networkClient.perform(req)
//            .decode(type: BalabobaModeEndpoint.Response.self, decoder: JSONDecoder())
//            .map { $0.intros.map { intro in
//                intro.map { introent in
//                    switch introent {
//                    case .integer(<#T##Int#>)
//                    }
//                }
//            }
//            }
    }
    
    func withMode(_ id: UInt) -> BalabobaStringTransformer {
        currentMode = modeList[Int(id)]
        return self
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        let body = BalabobaEndpoint.Body(query: string, intro: Int(currentMode.id))
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
    
    struct BalabobaModeEndpoint {
        
        struct Response: Decodable {
            let error: Int
            let intros: [[Intro]]
            
            enum Intro: Codable {
                case integer(Int)
                case string(String)
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    if let x = try? container.decode(Int.self) {
                        self = .integer(x)
                        return
                    }
                    if let x = try? container.decode(String.self) {
                        self = .string(x)
                        return
                    }
                    throw DecodingError.typeMismatch(Intro.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Intro"))
                }
                
            }
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
        case .balaboba(let value): return BalabobaStringTransformer.shared.withMode(value)
        case .mock: return StringTransfomerMock()
        }
    }
    
    var descriptionD: [StringTransformerOptionProtocol] {
        switch self {
        case .balaboba: return BalabobaStringTransformer.shared.modeList
        case .mock: return SmileyStringTransformer(0).modeList
        }
    }
    
    /// Description for case.
    var description: String {
        switch self {
        case .balaboba: return BalabobaStringTransformer.shared.name
        case .mock: return SmileyStringTransformer(0).name
        }
    }
}



// strategy container

class BeliberdalService: StringTransformerProtocol {
    
    var name: String {
        "belib"
    }
    
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
