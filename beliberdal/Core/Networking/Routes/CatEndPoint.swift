//
//  CatEndPoint.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation

enum CatEndPoint {
    case search
    case kitty(query: String)
}

extension CatEndPoint: APIRouterProtocol {
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search, .kitty: return .GET
        }
    }
    
    var mainPath: String {
        switch self {
        case .search: return "https://api.thecatapi.com/v1/images/search"
        case .kitty(let query): return query
        }
    }
    
    var endpoint: String {
        ""
    }
    
    var body: Data? {
        nil
    }
    
}

extension CatEndPoint {
    
    struct Search {
        struct Response: Decodable {
            let url: String
        }
    }
    
}
