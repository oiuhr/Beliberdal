//
//  SmileyStringTransformerTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import XCTest
import Combine

@testable import beliberdal

class SmileyStringTransformerTests: XCTestCase {

    var cancellable = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellable.removeAll()
    }
    
    func testThatSmileyStringTransformerInitWithCorrectMode() throws {
        // arrange
        let sut = SmileyStringTransformer(for: .happy)
        
        // assert
        XCTAssertEqual(sut.currentMode, SmileyStringTransformer.Modes.happy)
    }
    
    func testThatSmileyStringTransformerReturnsResultMatchingWithItsMode() throws {
        // arrange
        let sut = SmileyStringTransformer(for: .happy)
        let stringToTransform = "пиво"
        
        let transformExpectation = expectation(description: "should return transformed string")
        let correctTransformExpectation = expectation(description: "should return string transformed for specific mode")
        
        // act
        sut.transform(stringToTransform)
            .filter { string in
                let filterResult = string != stringToTransform
                if filterResult { transformExpectation.fulfill() }
                return filterResult
            }
            .filter { $0 == stringToTransform + " :)" }
            .sink { _ in
            } receiveValue: { value in
                correctTransformExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        // assert
        wait(for: [transformExpectation, correctTransformExpectation], timeout: 1)
    }
    
    
}
