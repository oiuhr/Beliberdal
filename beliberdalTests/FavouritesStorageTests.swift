//
//  FavouritesStorageTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import XCTest
import Combine

@testable import beliberdal

class FavouritesStorageTests: XCTestCase {

    let container = MockCoreDataStack(modelName: "beliberdal")
    var cancellable = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellable.removeAll()
    }
    
    func testThatFavouritesStorageInitWithEmptyStorage() throws {
        let sut = FavouritesStorage(container: container)
        let expectation = expectation(description: "storage should be empty")
        
        sut.itemsPublisher
            .sink { values in
                if values.isEmpty { expectation.fulfill() }
            }
            .store(in: &cancellable)
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func testThatFavouritesStorageSavesItemCorrectly() throws {
        let sut = FavouritesStorage(container: container)
        let item = TransformerResultDTO(id: UUID(), transformerName: "mock", content: "mock")
        let expectation = expectation(description: "storage should add item")
        
        sut.save(item)
        
        sut.itemsPublisher
            .print()
            .filter { items in
                items.contains(item)
            }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        wait(for: [expectation], timeout: 3)
    }

}
