//
//  CatViewModel.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import UIKit
import Combine

struct CatViewModelInput {
    let fireAction: PassthroughSubject<Void, Never>
}

struct CatViewModelOutput {
    let image: AnyPublisher<UIImage, Never>
    let error: AnyPublisher<Void, Never>
}

protocol CatViewModelProtocol {
    var input: CatViewModelInput { get }
    var output: CatViewModelOutput { get }
}

class CatViewModel: CatViewModelProtocol {
    
    let input: CatViewModelInput
    let output: CatViewModelOutput
    
    /// input
    private let fireAction = PassthroughSubject<Void, Never>()
    
    /// output
    private let image = PassthroughSubject<UIImage, Never>()
    private let error = PassthroughSubject<Void, Never>()
    
    /// local
    private let catService: CatServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(catService: CatServiceProtocol) {
        self.catService = catService
        
        self.input = .init(fireAction: fireAction)
        self.output = .init(image: image.eraseToAnyPublisher(), error: error.eraseToAnyPublisher())
        
        fireAction
            .sink { [weak self] _ in
                self?.perform()
            }
            .store(in: &cancellable)
    }
    
    private func perform() {
        catService.randomKitty()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure: self?.error.send()
                default: break
                }
            } receiveValue: { [weak self] image in
                self?.image.send(image)
            }
            .store(in: &cancellable)
    }
    
}
