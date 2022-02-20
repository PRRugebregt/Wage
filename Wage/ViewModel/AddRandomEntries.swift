//
//  AddRandomEntries.swift
//  Wage
//
//  Created by Patrick Rugebregt on 20/02/2022.
//

import Foundation

class AddRandomEntries {
    
    // For testing purposes create 71 new random entries
    func create() {
        for _ in 0 ... 70 {
            let file = WageFile(
                                id: Int64.random(in: 0 ..< Int64.max),
                                wage: Int.random(in: 100...500), artistType: ArtistType.allCases.randomElement()!, gigType: GigType.allCases.randomElement()!, yearsOfExperience: Int.random(in: 2 ... 20), didStudy: Bool.random(), instrument: Instrument.allCases.randomElement()!)
            PersistenceController.shared.createObject(wageFile: file)
        }
    }
    
}


