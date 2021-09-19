//
//  SettingsViewModelTests.swift
//  beliberdalTests
//
//  Created by Ryzhov Eugene on 16.09.2021.
//

import XCTest
import Combine

@testable import beliberdal

class SettingsViewModelTests: XCTestCase {

    var sut: SettingsViewModelProtocol?
    var settings: SettingsServiceMock?
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        settings = SettingsServiceMock()
        sut = SettingsViewModel(settings! as SettingsServiceProtocol)
    }

    override func tearDownWithError() throws {
        cancellable.removeAll()
        sut = nil
        settings = nil
    }
    
    func testThatViewModelReactsToSwitchModeSignal() {
        // arrange
        
        // act
        sut?.input.switchMode.send(.smiley(mode: .sad))
        
        // assert
        XCTAssertTrue(settings!.tryedToSwitchMode)
    }


}
