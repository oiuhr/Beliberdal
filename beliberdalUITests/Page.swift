//
//  Page.swift
//  beliberdalUITests
//
//  Created by Ryzhov Eugene on 20.09.2021.
//

import XCTest

protocol Page {
    var app: XCUIApplication { get }

    init(app: XCUIApplication)
}

class MainPage: Page {
    
    var app: XCUIApplication

    required init(app: XCUIApplication) {
        self.app = app
    }
    
    private var settingsButton: XCUIElement { return app.buttons["settingsButton"] }
    
    func tapOnSettingsButton() -> SettingsPage {
        settingsButton.tap()
        return SettingsPage(app: app)
    }
    
}

class SettingsPage: Page {
    
    var app: XCUIApplication

    required init(app: XCUIApplication) {
        self.app = app
    }
    
    private var tableView: XCUIElement {
        return app.tables.element(matching: .table, identifier: "settingsTableView")
    }
    
    func checkTableViewExists(completion: @escaping (Bool) -> Void) {
        completion(tableView.exists)
    }
    
}

