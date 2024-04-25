//
//  ConisUITests.swift
//  ConisUITests
//
//  Created by Bismillah on 19/4/2567 BE.
//

import XCTest

final class ConisUITests: XCTestCase {
    let app = XCUIApplication()
    private typealias id = AccessibilityId.Home
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}

extension ConisUITests {
    func testLaunchScreen() {
        
    }
    
    func testViewInitialization() {
        let tableView = app.tables
        XCTAssertNotNil(tableView)

        let search = app.searchFields["Search"]
        XCTAssertNotNil(search)
    }
    
    func testTableView() {
        let tableView = app.tables
        XCTAssertNotNil(tableView)
        tableView.element.swipeDown()
        XCTAssertEqual(tableView.cells.count, 11)
        
        let CellExpectation = XCTestExpectation(description: "All cells are visible")

        let listCell = tableView.cells[id.listCell.rawValue]
        let topRankCell = tableView.cells[id.topRankCell.rawValue]
        let titleCell = tableView.cells[id.titleCell.rawValue]
        let inviteCell = tableView.cells[id.inviteCell.rawValue]

        let allCells = [listCell, topRankCell, titleCell, inviteCell]

        let handler = { () -> Bool in
            return allCells.allSatisfy { $0.exists }
        }

        DispatchQueue.global().async {
            while !handler() {
                usleep(100000)
            }
            CellExpectation.fulfill()
        }

        wait(for: [CellExpectation], timeout: 5)
    }
    
    func testsCellTap() {
        let tableView = app.tables
        XCTAssertNotNil(tableView)
    }
}
