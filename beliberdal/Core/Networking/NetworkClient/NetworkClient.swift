//
//  NetworkClient.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import Foundation
import Combine

struct NetworkClient: NetworkClientProtocol {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    init() {
        self.init(session: URLSession.shared)
    }
    
    func perform(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
