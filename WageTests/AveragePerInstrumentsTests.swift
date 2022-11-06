//
//  AveragePerInstrumentsTests.swift
//  WageTests
//
//  Created by Patrick Rugebregt on 23/10/2022.
//

import XCTest
@testable import Wage

final class AveragePerInstrumentsTests: XCTestCase {

    var sut: AveragePerInstrumentViewModel?

    
    override func setUpWithError() throws {
        sut = AveragePerInstrumentViewModel(dependencies: MockDependencies())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCalculateAverage() throws {
        let testData = TestData.wageFiles
        let averagesBedrijfsFeest = sut?.calculateAllAverages(for: .bedrijfsfeest, withFiles: testData)
        XCTAssertEqual(averagesBedrijfsFeest?[Instrument.Gitaar.rawValue], 321)
        let averagesFestival = sut?.calculateAllAverages(for: .festival, withFiles: testData)
        XCTAssertEqual(averagesFestival?[Instrument.Gitaar.rawValue], 380)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
