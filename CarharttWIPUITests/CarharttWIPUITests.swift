//
//  CarharttWIPUITests.swift
//  CarharttWIPUITests
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import XCTest

final class CarharttWIPUITests: XCTestCase {
    @MainActor
    func testRoundResultsReplayAndClose() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["game.start"].tap()
        let like = app.buttons["game.like"]
        XCTAssertTrue(like.waitForExistence(timeout: 5))
        for remaining in stride(from: 10, through: 1, by: -1) {
            XCTAssertTrue(app.staticTexts["game.remaining"].label.contains("\(remaining)"))
            like.tap()
        }
        XCTAssertTrue(app.staticTexts["results.title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["results.title"].label.contains("10/10"))
        app.buttons["results.addToCart"].tap()
        XCTAssertTrue(app.staticTexts["results.toast"].waitForExistence(timeout: 3))
        app.buttons["results.close"].tap()
        XCTAssertTrue(like.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["game.remaining"].label.contains("10"))
        app.buttons["game.close"].tap()
        XCTAssertTrue(app.buttons["game.start"].waitForExistence(timeout: 3))
    }

    @MainActor
    func testAllDislikedRoundShowsEmptyResults() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["game.start"].tap()
        let dislike = app.buttons["game.disLike"]
        XCTAssertTrue(dislike.waitForExistence(timeout: 5))
        for _ in 0..<10 { dislike.tap() }
        XCTAssertTrue(app.staticTexts["results.title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["results.title"].label.contains("0/10"))
        XCTAssertFalse(app.buttons["results.addToCart"].exists)
    }

    @MainActor
    func testDirectionalSwipesAndRejectedDownwardDrag() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["game.start"].tap()
        XCTAssertTrue(app.buttons["game.like"].waitForExistence(timeout: 5))
        attachScreenshot(app, name: "Reaction screen")
        let closeFrame = app.buttons["game.close"].frame

        drag(app, from: CGVector(dx: 0.5, dy: 0.3), to: CGVector(dx: 0.5, dy: 0.65))
        XCTAssertTrue(app.staticTexts["game.remaining"].label.contains("10"))
        drag(app, from: CGVector(dx: 0.15, dy: 0.4), to: CGVector(dx: 0.95, dy: 0.4))
        XCTAssertTrue(app.staticTexts["game.remaining"].label.contains("9"))
        drag(app, from: CGVector(dx: 0.85, dy: 0.4), to: CGVector(dx: 0.05, dy: 0.4))
        XCTAssertTrue(app.staticTexts["game.remaining"].label.contains("8"))
        drag(app, from: CGVector(dx: 0.5, dy: 0.6), to: CGVector(dx: 0.5, dy: 0.15))
        XCTAssertTrue(app.staticTexts["game.remaining"].label.contains("7"))
        XCTAssertEqual(app.buttons["game.close"].frame, closeFrame)
        for _ in 0..<7 { app.buttons["game.disLike"].tap() }
        XCTAssertTrue(app.staticTexts["results.title"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["results.title"].label.contains("2/10"))
        attachScreenshot(app, name: "Mixed reaction results")
    }

    @MainActor
    private func drag(_ app: XCUIApplication, from start: CGVector, to end: CGVector) {
        app.coordinate(withNormalizedOffset: start).press(
            forDuration: 0.05, thenDragTo: app.coordinate(withNormalizedOffset: end)
        )
    }

    @MainActor
    private func attachScreenshot(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
