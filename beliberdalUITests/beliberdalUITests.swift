//
//  beliberdalUITests.swift
//  beliberdalUITests
//
//  Created by Ryzhov Eugene on 04.07.2021.
//

import XCTest
import SnapshotTesting
@testable import beliberdal

class beliberdalUITests: XCTestCase {

    func testSnapshotExample() {
        let catService = CatService(networkClient: NetworkClient(), requestBuilder: RequestBuilder())
        let vm = CatViewModel(catService: catService)
        let vc = CatViewController(vm)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneSe))
    }

    func testSettingsModuleIsReachable() throws {
        let app = XCUIApplication()
        app.launch()
        let mainPage = MainPage(app: app)
        mainPage.tapOnSettingsButton()
            .checkTableViewExists {
                XCTAssertTrue($0)
            }
    }
    
}
