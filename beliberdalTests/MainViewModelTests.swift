//
//  MainViewModelTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 20.09.2021.
//

import XCTest
import Combine

@testable import beliberdal

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel?
    var storage: FavouritesStorageMock?
    var settings: SettingsServiceMock?
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        storage = FavouritesStorageMock()
        settings = SettingsServiceMock()
        sut = MainViewModel(settingsService: settings!, favouritesStorage: storage!)
    }

    override func tearDownWithError() throws {
        cancellable.removeAll()
        sut = nil
        storage = nil
        settings = nil
    }
    
    func testThatViewModelReactsToInputSignalAndReturnsCorrectModes() {
        // arrange
        settings?._strategy.value = .smiley(mode: .happy)
        let valueToTransform = "пиво"
        
        let contentExpectation = expectation(description: "should return .content state")
        let loadingExpectation = expectation(description: "should return .loading state")
        
        sut?.output.currentMode
            .dropFirst()
            .sink { mode in
                switch mode {
                case .content(let initialValue, let content):
                    XCTAssertEqual(initialValue, valueToTransform,
                                   "transform result initial value and string sent to viewModel input should be equal")
                    XCTAssertEqual(content, valueToTransform + " :)",
                                   "should return expected transform result")
                    contentExpectation.fulfill()
                case .loading:
                    loadingExpectation.fulfill()
                default: XCTFail("viewModel send unexpected mode")
                }
            }
            .store(in: &cancellable)
        
        // act
        sut?.input.transformAction.send(valueToTransform)
        
        // assert
        wait(for: [contentExpectation, loadingExpectation], timeout: 1)
    }
    
    func testThatViewModelReactsToOpenCatsSignal() {
        // arrange
        let expectation = expectation(description: "openCats should be triggered")
        sut?.openCats = { _ in expectation.fulfill() }
        
        // act
        sut?.input.openCatsAction.send()
        
        // assert
        XCTAssertNotNil(sut?.openCats)
        wait(for: [expectation], timeout: 1)
    }
    
    func testThatViewModelReactsToOpenSettingsSignal() {
        // arrange
        let expectation = expectation(description: "openSettings should be triggered")
        sut?.openSettings = { expectation.fulfill() }
        
        // act
        sut?.input.openSettingsAction.send()
        
        // assert
        XCTAssertNotNil(sut?.openSettings)
        wait(for: [expectation], timeout: 1)
    }
    
    func testThatViewModelReactsToSaveToFavouritesSignal() {
        // arrange
        let expectation = expectation(description: "saveAction should be triggered")
        
        // act
        settings?._strategy.value = .smiley(mode: .happy)
        sut?.input.transformAction.send("пиво")
        sut?.output.currentMode
            .filter { mode in
                if case .content = mode {
                    return true
                }
                return false
            }
            .sink { [weak self] _ in
                self?.sut?.input.addToFavouritesAction.send()
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        // assert
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(storage!.tryedToSave)
    }
    
}
