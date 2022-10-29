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
    let testData: [WageFile] = [
        WageFile(id: 0, wage: 250, artistType: .Midden, gigType: .bedrijfsfeest, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 300, artistType: .Midden, gigType: .bedrijfsfeest, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 400, artistType: .Midden, gigType: .bedrijfsfeest, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 100, artistType: .Midden, gigType: .bedrijfsfeest, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 125, artistType: .Midden, gigType: .bedrijfsfeest, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 751, artistType: .Midden, gigType: .bedrijfsfeest, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 500, artistType: .Midden, gigType: .festival, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 350, artistType: .Midden, gigType: .festival, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 450, artistType: .Midden, gigType: .festival, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 350, artistType: .Midden, gigType: .festival, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
        WageFile(id: 0, wage: 250, artistType: .Midden, gigType: .festival, yearsOfExperience: 8, didStudy: true, instrument: .Gitaar, timeStamp: .now),
    ]
    
    override func setUpWithError() throws {
        sut = AveragePerInstrumentViewModel(dependencies: MockDependencies())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCalculateAverage() throws {
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
