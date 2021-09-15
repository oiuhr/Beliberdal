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
    
    func testThatBalabobaStringTransformerInitWithCorrectMode() throws {
        // arrange
//        let sut = BalabobaStringTransformer(for: .none,
//                                               networkClient: NetworkClientMock(result: .success("d".data(using: .utf8)!)))
        
        // assert
//        XCTAssertEqual(sut.currentMode, BalabobaStringTransformer.Modes.none)
    }
    
}
