//
//  NetworkClientMock.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 14.09.2021.
//

import Foundation
import Combine
@testable import beliberdal

struct NetworkClientMock: NetworkClientProtocol {
    
    var result: Result<Data, Error>
  
    func perform(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        result.publisher
            .eraseToAnyPublisher()
    }

}
