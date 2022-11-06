//
//  FilteringTests.swift
//  WageTests
//
//  Created by Patrick Rugebregt on 06/11/2022.
//

import XCTest
@testable import Wage

final class FilteringTests: XCTestCase {

    let testData = TestData.wageFiles
    let sut = Filtering(dependencies: MockDependencies())
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testWageMinimum() {
        sut.changeWageMinimum(with: 500 / 1000)
        XCTAssertEqual(sut.filterOptions.wageLowLimit, 500)
        let filtered = sut.filterWageFiles(testData, with: sut.filterOptions)
        for wageFile in filtered {
            XCTAssertGreaterThanOrEqual(wageFile.wage, 500)
        }
    }
    
    func testWageMaximum() {
        sut.changeWageMaximum(with: 500 / 1000)
        XCTAssertEqual(sut.filterOptions.wageHighLimit, 500)
        let filtered = sut.filterWageFiles(testData, with: sut.filterOptions)
        for wageFile in filtered {
            XCTAssertLessThanOrEqual(wageFile.wage, 500)
        }
    }
    
    func testFilterByGigType() {
        let gigType = GigType.festival
        sut.changeFilterGigType(to: gigType)
        XCTAssertEqual(sut.filterOptions.gigType, gigType)
        let filtered = sut.filterWageFiles(testData, with: sut.filterOptions)
        for wageFile in filtered {
            XCTAssertTrue(wageFile.gigType == gigType)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
