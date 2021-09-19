//
//  CatEndPoint.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation

enum CatEndPoint {
    case kitty(query: String)
}

extension CatEndPoint: APIRouterProtocol {
    
    var httpMethod: HTTPMethod {
        switch self {
        case .kitty: return .GET
        }
    }
    
    var mainPath: String {
        switch self {
        case .kitty: return "https://cataas.com/cat/says/"
        }
    }
    
    var endpoint: String {
        switch self {
        case .kitty(let query): return query
        }
    }
    
    var body: Data? {
        nil
    }
    
}
