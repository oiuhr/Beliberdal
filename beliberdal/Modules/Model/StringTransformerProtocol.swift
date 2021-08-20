//
//  StringTransformerProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import Combine
import Foundation

enum StringTransformerError: Error {
    case undefined
}

/// Protocol for any entity that could transform given string.
protocol StringTransformerProtocol {
    /// Transforms given string to any nonsense.
    func transform(_ string: String) -> AnyPublisher<String, Error>
}

struct StringTransfomerMock: StringTransformerProtocol {
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        Just(string + " :)")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

struct BalabobaStringTransformer: StringTransformerProtocol {
    
    private let networkClient = NetworkClient()
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        let body = BalabobaEndpoint.Body(query: string, intro: 4, filter: 1)
        let request = jsonPostRequest(endpoint: BalabobaEndpoint.endpoint, jsonBody: body)
        
        return networkClient.perform(request)
            .decode(type: BalabobaEndpoint.Response.self, decoder: JSONDecoder())
            .map { "\($0.query + $0.text)" }
            .eraseToAnyPublisher()
    }
    
    func jsonPostRequest<Body: Encodable>(endpoint: String, jsonBody: Body) -> URLRequest {
        let url = URL(string: endpoint)!
        let method = "POST"
        let encoded = try! JSONEncoder().encode(jsonBody)
        let headers = [
            "Accept": "application/json",
            "Content-Length": "\(encoded.count)",
            "Content-Type": "application/json",
            "Connection": "keep-alive"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = encoded
        request.timeoutInterval = 10
        
        return request
    }
    
}

extension BalabobaStringTransformer {
    
    struct BalabobaEndpoint {
        
        static var endpoint = "https://zeapi.yandex.net/lab/api/yalm/text3"
        
        struct Body: Encodable {
            let query: String
            let intro: Int
            let filter: Int
        }
        
        struct Response: Decodable {
            let bad_query: Int
            let error: Int
            let query: String
            let text: String
        }
        
    }
    
}

enum StringTransformerType {
    /**
        Yandex Balaboba wrapper.
        Could be extended with its styles; currently unsupported
        - note: TODO – balaboba(mode: Int)
     */
    case balaboba
        
    /// Mock used for testing purposes.
    case mock

    /// Helper computed variable to init class from enum value.
    var entityForType: StringTransformerProtocol {
        switch self {
        case .balaboba: return BalabobaStringTransformer()
        case .mock: return StringTransfomerMock()
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
            .dropFirst()
            .sink { [weak self] mode in
                self?.strategy = mode.entityForType
                print(mode, self?.strategy as Any)
            }
            .store(in: &cancellable)
    }
    
    func transform(_ string: String) -> AnyPublisher<String, Error> {
        strategy?.transform(string) ?? Fail<String, Error>
                                            .init(error: StringTransformerError.undefined)
                                            .eraseToAnyPublisher()
    }
    
}

protocol SettingsServiceProtocol {
    var strategy: CurrentValueSubject<StringTransformerType, Never> { get }
    func setStrategy(_ strategy: StringTransformerType)
}

final class SettingsService: SettingsServiceProtocol {
    private(set) var strategy: CurrentValueSubject<StringTransformerType, Never> = .init(.mock)
    
    static let shared = SettingsService()
    
    init(_ strategy: StringTransformerType) {
        self.strategy.value = .mock
    }
    
    convenience init() {
        self.init(.mock)
    }

    func setStrategy(_ strategy: StringTransformerType) {
        self.strategy.value = strategy
    }
}
