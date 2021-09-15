//
//  NetworkClientProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 14.09.2021.
//

import Foundation
import Combine

protocol NetworkClientProtocol {
    func perform(_ request: URLRequest) -> AnyPublisher<Data, Error>
}
