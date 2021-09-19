//
//  CatViewModelTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 16.09.2021.
//

import UIKit
import Combine
import XCTest

@testable import beliberdal

class CatViewModelTests: XCTestCase {

    var sut: CatViewModelProtocol?
    var networkClientMock: NetworkClientMock?
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        networkClientMock = NetworkClientMock()
        let catService = CatService(networkClient: networkClientMock! as NetworkClientProtocol,
                                    requestBuilder: RequestBuilder())
        sut = CatViewModel(catService: catService, initialPhrase: "пиво")
    }

    override func tearDownWithError() throws {
        cancellable.removeAll()
        sut = nil
        networkClientMock = nil
    }
    
    func testThatViewModelReturnsValueToFireSignal() {
        // arrange
        let expectation = expectation(description: "should return image as a react to signal")
        let data = UIImage(systemName: "circle.fill")!.pngData()!
        networkClientMock?.result = .success(data)
        sut?.output.image
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        // act
        sut?.input.fireAction.send()
        
        // assert
        wait(for: [expectation], timeout: 1)
    }
    
    func testThatViewModelReturnErrorSignalOnCatServiceError() {
        // arrange
        let expectation = expectation(description: "should return error from catService error")
        let networkError = URLError.init(.badURL)
        networkClientMock?.result = .failure(networkError)
        
        sut?.output.error
            .sink { error in
                if (error as NSError) == (networkError as NSError) { expectation.fulfill() }
            }
            .store(in: &cancellable)
        
        // act
        sut?.input.fireAction.send()
        
        // assert
        wait(for: [expectation], timeout: 1)
    }

}
