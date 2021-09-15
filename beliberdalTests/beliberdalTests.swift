//
//  beliberdalTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 04.07.2021.
//

import XCTest
import Combine
@testable import beliberdal

class beliberdalTests: XCTestCase {

    var cancellable = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellable.removeAll()
    }
    
    func testThatNetworkClientReturnsData() throws {
        let data = "data".data(using: .utf8)!
        let client = NetworkClientMock(result: .success(data))
        
        let expectation = expectation(description: "data loading")
        client.perform(URLRequest(url: URL(string: "f")!))
            .sink { completion in
                print(completion)
            } receiveValue: { data in
                expectation.fulfill()
            }
            .store(in: &cancellable)

        wait(for: [expectation], timeout: 1)
    }

}
