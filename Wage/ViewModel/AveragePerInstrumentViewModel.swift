//
//  AveragePerInstrumentViewModel.swift
//  Wage
//
//  Created by Patrick Rugebregt on 09/03/2022.
//

import Foundation

class AveragePerInstrumentViewModel: ObservableObject {
    
    @Published var allAverages: [String:Int] = [:]
    private var wageFileLoader: WageFileLoader
    private var files: [WageFile] = []
    
    init(dependencies: HasWageFileLoader) {
        self.wageFileLoader = dependencies.injectWageFileLoader()
    }
    
    func loadAverageResultsPerInstrument(for gigType: GigType) {
        allAverages = calculateAllAverages(for: gigType)
    }
    
    func calculateAllAverages(for gigType: GigType, withFiles wageFiles: [WageFile]? = nil) -> [String:Int] {
        let files = wageFiles == nil ? wageFileLoader.wageFiles : wageFiles!
        var localAllAverages: [String:Int] = [:]
        
        for instrument in Instrument.allCases {
            let instrumentName = instrument.rawValue
            // Calculate number of instrument entries
            let numberOfEntries = files.compactMap(
                { $0.gigType == gigType && $0.instrument == instrument ? instrument : nil }
            ).count
            // Calculate the sum of the wages of the instrument in loop for the selected gigType
            let sum = files
                .compactMap { $0.gigType == gigType && $0.instrument == instrument ? $0.wage : nil }
                .reduce(0, { $0 + $1 })
            // Save the averages in the dictionary to display in list
            // If there are no entries, make sure to divide by at least 1 (or else it will crash: NoN)
            localAllAverages[instrumentName] = sum / (numberOfEntries == 0 ? 1 : numberOfEntries)
        }
        
        return localAllAverages
    }
}
