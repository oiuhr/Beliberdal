//
//  BalabobaStringTransformerTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import XCTest
import Combine

@testable import beliberdal

class BalabobaStringTransformerTests: XCTestCase {

    var cancellable = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellable.removeAll()
    }
    
    func testThatBalabobaStringTransformerReturnsCorrectValue() throws {
        // arrange
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "BalabobaResponse", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("could not load data for BalabobaResponse")
            return
        }
        let mockNetworkClient = NetworkClientMock()
        mockNetworkClient.result = .success(data)
        let sut = BalabobaStringTransformer(for: .quotes,
                                               networkClient: mockNetworkClient,
                                               requestBuilder: RequestBuilder())
        let expectation = expectation(description: "BalabobaStringTransformer should return correct value")
        
        // act
        sut.transform("пиво")
            .sink { _ in
            } receiveValue: { value in
                expectation.fulfill()
            }
            .store(in: &cancellable)

        // assert
        wait(for: [expectation], timeout: 1)
    }
    
}
