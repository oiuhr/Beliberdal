//
//  RequestBuilder.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import Foundation

protocol RequestBuilderProtocol {
    func request(for route: APIRouterProtocol) -> URLRequest?
}

final class RequestBuilder: RequestBuilderProtocol {
    
    func request(for route: APIRouterProtocol) -> URLRequest? {
        guard var url = URL(string: route.mainPath) else { return nil }
        if route.endpoint != "" { url = url.appendingPathComponent(route.endpoint) }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Connection": "keep-alive"
        ]
        if let encoded = route.body {
            request.httpBody = encoded
            request.allHTTPHeaderFields?["Content-Length"] = "\(encoded.count)"
        }
        
        request.httpMethod = route.httpMethod.rawValue
        
        return request
    }
    
}
