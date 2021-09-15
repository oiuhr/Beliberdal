//
//  CatService.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation
import Combine
import UIKit

protocol CatServiceProtocol {
    func randomKitty() -> AnyPublisher<UIImage, Error>
}

class CatService: CatServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    
    init(networkClient: NetworkClientProtocol, requestBuilder: RequestBuilderProtocol) {
        self.networkClient = networkClient
        self.requestBuilder = requestBuilder
    }

    func randomKitty() -> AnyPublisher<UIImage, Error> {
        guard let request = requestBuilder.request(for: CatEndPoint.search) else {
            return Fail<UIImage, Error>.init(error: URLError.init(.badURL))
                .eraseToAnyPublisher()
        }
        
        return networkClient.perform(request)
            .decode(type: [CatEndPoint.Search.Response].self, decoder: JSONDecoder())
            .compactMap { $0.first }
            .map { $0.url }
            .map { [weak self] url -> AnyPublisher<UIImage, Error> in
                guard let strongSelf = self,
                        let srequest = strongSelf.requestBuilder.request(for: CatEndPoint.kitty(query: url)) else {
                    return Fail<UIImage, Error>.init(error: URLError.init(.badURL))
                        .eraseToAnyPublisher()
                }
                
                return strongSelf.networkClient.perform(srequest)
                    .compactMap { data in
                        UIImage(data: data)
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
            
            
    }
    
}
