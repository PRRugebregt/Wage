//
//  Filter.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import UIKit

class Filtering: ObservableObject {
    
    private var filteredItems: [WageFile] = []
    @Published var filterOptions: FilterOptions = FilterOptions()
    var minimumWage = 0
    var maximumWage = 1000
    var isFiltered = false
    
    init() {

    }
    
    // Intent functions
    
    func changeGigType(to option: GigType) {
        filterOptions.changeGigType(to: option)
        isFiltered = true
    }
    
    func changeArtistType(to option: ArtistType) {
        filterOptions.changeArtistType(to: option)
        isFiltered = true
    }
    
    func changeWageMinimum(with value: CGFloat) {
        let intValue = Int(value * 1000)
        minimumWage = intValue
        filterOptions.changeWageMinimum(with: intValue)
        isFiltered = true
    }
    
    func changeWageMaximum(with value: CGFloat) {
        let intValue = Int(value * 1000)
        maximumWage = intValue
        filterOptions.changeWageMaximum(with: intValue)
        isFiltered = true
    }
    
    func reset() {
        filterOptions = FilterOptions()
        isFiltered = false
    }
    
}

