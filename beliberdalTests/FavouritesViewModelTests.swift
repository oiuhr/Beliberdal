//
//  FavouritesViewModelTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 16.09.2021.
//

import XCTest
import Combine

@testable import beliberdal

class FavouritesViewModelTests: XCTestCase {

    var sut: FavouritesViewModelProtocol?
    var storage: FavouritesStorageMock?
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        storage = FavouritesStorageMock()
        sut = FavouritesViewModel(favouritesStorage: storage! as FavouritesStorageProtocol)
    }

    override func tearDownWithError() throws {
        cancellable.removeAll()
        sut = nil
        storage = nil
    }
    
    func testThatViewModelReactsToDeleteSignal() {
        let item = TransformerResultDTO(id: UUID(), transformerName: "", content: "")
        
        sut?.input.deleteAction.send(item)
        
        XCTAssertTrue(storage!.tryedToDelete)
    }

}
