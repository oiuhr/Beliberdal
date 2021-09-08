//
//  RequestBuilder.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import Foundation

// MARK: TODO - Tests

struct RequestBuilder {
    
    
    
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
