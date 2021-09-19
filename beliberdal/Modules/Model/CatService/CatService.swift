//
//  CatService.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation
import Combine
import UIKit

class CatService: CatServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    
    init(networkClient: NetworkClientProtocol, requestBuilder: RequestBuilderProtocol) {
        self.networkClient = networkClient
        self.requestBuilder = requestBuilder
    }

    func randomKitty(saying phrase: String) -> AnyPublisher<UIImage, Error> {
        guard let request = requestBuilder.request(for: CatEndPoint.kitty(query: phrase)) else {
            return Fail<UIImage, Error>.init(error: URLError.init(.badURL))
                .eraseToAnyPublisher()
        }
        
        return networkClient.perform(request)
            .compactMap { UIImage(data: $0) }
            .eraseToAnyPublisher()
            
    }
    
}
