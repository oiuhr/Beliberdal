//
//  NetworkClientMock.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 14.09.2021.
//

import Foundation
import Combine
@testable import beliberdal

class NetworkClientMock: NetworkClientProtocol {
    
    var result: Result<Data, Error>?
  
    func perform(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        guard let result = self.result else { fatalError("networkClientMock should have result to return.") }
        return result.publisher
            .eraseToAnyPublisher()
    }

}
