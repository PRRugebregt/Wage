//
//  FilterOptions.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation

struct FilterOptions {
    
    var gigType: GigType?
    var wageLowLimit: Int?
    var wageHighLimit: Int?
    var artistType: ArtistType?
    var instrumentType: Instrument?
    
    mutating func changeGigType(to option: GigType) {
        self.gigType = option
    }
    
    mutating func changeArtistType(to option: ArtistType) {
        self.artistType = option
    }
    
    mutating func changeWageMinimum(with value: Int) {
        self.wageLowLimit = value
    }
    
    mutating func changeWageMaximum(with value: Int) {
        self.wageHighLimit = value
    }
    
    mutating func changeInstrument(to instrument: Instrument) {
        self.instrumentType = instrument
    }
    
}
