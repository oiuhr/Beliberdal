//
//  APIRouter.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

protocol APIRouterProtocol {
    var httpMethod: HTTPMethod { get }
    var mainPath: String { get }
    var endpoint: String { get }
    var body: Data? { get }
}
