//
//  beliberdalUITests.swift
//  beliberdalUITests
//
//  Created by Ryzhov Eugene on 04.07.2021.
//

import XCTest

class beliberdalUITests: XCTestCase {

    func testFireButtonTapIsHandled() throws {
        let app = XCUIApplication()
        app.launch()
        let fireButton = app.buttons["fire"]
        
        fireButton.tap()

        XCTAssert(app.textViews["output"].value as! String == "Пиво :)")
    }

}
