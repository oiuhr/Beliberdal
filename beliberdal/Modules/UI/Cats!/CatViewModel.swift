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
    let kittyPhrase: CurrentValueSubject<String, Never>
}

struct CatViewModelOutput {
    let image: AnyPublisher<UIImage, Never>
    let error: AnyPublisher<Error, Never>
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
    private let kittyPhrase = CurrentValueSubject<String, Never>("")
    
    /// output
    private let image = PassthroughSubject<UIImage, Never>()
    private let error = PassthroughSubject<Error, Never>()
    
    /// local
    private let catService: CatServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(catService: CatServiceProtocol, initialPhrase: String = "Hello") {
        self.catService = catService
        self.kittyPhrase.value = initialPhrase
        self.input = .init(fireAction: fireAction, kittyPhrase: kittyPhrase)
        self.output = .init(image: image.eraseToAnyPublisher(), error: error.eraseToAnyPublisher())
        
        fireAction
            .sink { [weak self] _ in
                self?.perform()
            }
            .store(in: &cancellable)
    }
    
    private func perform() {
        catService.randomKitty(saying: kittyPhrase.value)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.error.send(error)
                default: break
                }
            } receiveValue: { [weak self] image in
                self?.image.send(image)
            }
            .store(in: &cancellable)
    }
    
}
