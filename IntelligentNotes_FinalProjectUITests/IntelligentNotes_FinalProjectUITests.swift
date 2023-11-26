//
//  IntelligentNotes_FinalProjectUITests.swift
//  IntelligentNotes_FinalProjectUITests
//
//  Created by Rayhan Faizel on 15/11/23.
//

import XCTest

final class IntelligentNotes_FinalProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testCreateNote() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.tables["folderList"].cells.element(boundBy: 0).tap()
        app.buttons["createNote"].tap()
        app.textFields["titleField"].tap()
        app.typeText("Test title")
        app.textViews["contentField"].tap()
            
        app.typeText("Test content")
        app.buttons["dismiss"].tap()
        app.buttons["saveButton"].tap()
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Test title")

        XCTAssert(app.collectionViews["noteCollection"].cells.containing(predicate).count > 0)
        
        app.collectionViews["noteCollection"].cells.containing(predicate).element(boundBy: 0).tap()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
