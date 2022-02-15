//
//  Filter.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation

class Filtering: ObservableObject {
    
    private var filteredItems: [WageFile] = []
    @Published var filterOptions: FilterOptions = FilterOptions()
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
    
    func changeWageMinimum(with value: String) {
        guard let intValue = Int(value) else { return }
        filterOptions.changeWageMinimum(with: intValue)
        isFiltered = true
    }
    
    func changeWageMaximum(with value: String) {
        guard let intValue = Int(value) else { return }
        filterOptions.changeWageMaximum(with: intValue)
        isFiltered = true
    }
    
    func reset() {
        filterOptions = FilterOptions()
        isFiltered = false
    }
    
}

