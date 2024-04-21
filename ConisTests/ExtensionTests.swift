//
//  ExtensionTests.swift
//  ConisTests
//
//  Created by Bismillah on 21/4/2567 BE.
//

import XCTest

final class ExtensionTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testMillionConverter() {
        var number = "1000000"
        var formattedNumber = number.formatNumber(2)
        XCTAssertEqual(formattedNumber, "1 million")
        
        number = "664027697"
        formattedNumber = number.formatNumber(2)
        XCTAssertEqual(formattedNumber, "664.03 million")
    }
    
    func testBillionConverter() {
        var number = "1000000000"
        var formattedNumber = number.formatNumber(2)
        XCTAssertEqual(formattedNumber, "1 billion")
        
        number = "10023400"
        formattedNumber = number.formatNumber(2)
        XCTAssertEqual(formattedNumber, "10.02 million")
    }
    
    func testTrillionConverter() {
        var number = "1000000000000"
        var formattedNumber = number.formatNumber(2)
        XCTAssertEqual(formattedNumber, "1 trillion")
        
        number = "111005000102346"
        formattedNumber = number.formatNumber(2)
        XCTAssertEqual(formattedNumber, "111.01 trillion")
    }
    
    func testCurrencyFormatter() {
        let number: Double = 64890.42977683232
        XCTAssertEqual(number.formattedCurrency(5) , "US$64,890.42978")
        XCTAssertEqual(number.formattedCurrency(code: "THB", 5) , "THB 64,890.42978")
    }
}
