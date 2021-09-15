//
//  RequestBuilderTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import XCTest

@testable import beliberdal

struct MockApiRoute: APIRouterProtocol {
    var httpMethod: HTTPMethod = .GET
    var mainPath: String = "google.com/"
    var endpoint: String = "search"
    var body: Data? = try? JSONEncoder().encode(["q":"пиво"])
}

class RequestBuilderTests: XCTestCase {

    func testThatRequestBuilderReturnsCorrectValue() {
        // arrange
        let sut = RequestBuilder()
        let route = MockApiRoute()
        
        // act
        let request = sut.request(for: route)
        
        // assert
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpBody, route.body)
        XCTAssertEqual(request?.httpMethod, route.httpMethod.rawValue)
    }

}
