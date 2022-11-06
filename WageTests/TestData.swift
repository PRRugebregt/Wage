//
//  TestData.swift
//  WageTests
//
//  Created by Patrick Rugebregt on 06/11/2022.
//

import UIKit
@testable import Wage

struct TestData {
    
    static let wageFiles: [WageFile] = [
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
    
}
