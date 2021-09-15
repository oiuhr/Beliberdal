//
//  BalabobaEndPoint.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation

enum BalabobaEndPoint {
    case transform(mode: Int, query: String)
}

extension BalabobaEndPoint: APIRouterProtocol {
    
    var httpMethod: HTTPMethod {
        switch self {
        case .transform: return .POST
        }
    }
    
    var mainPath: String {
        "https://zeapi.yandex.net/lab/api/yalm/"
    }
    
    var endpoint: String {
        switch self {
        case .transform: return "text3"
        }
    }
    
    var body: Data? {
        switch self {
        case .transform(let mode, let query):
            return try? JSONEncoder().encode(Transform.Body(query: query, intro: mode))
        }
    }

}

extension BalabobaEndPoint {
    
    struct Transform {
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
