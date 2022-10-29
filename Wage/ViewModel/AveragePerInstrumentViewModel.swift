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
    
    func loadResults(gigType: GigType) {
        print("Loading results")
        allAverages = calculateAllAverages(for: gigType)
    }
    
    func calculateAllAverages(for gigType: GigType, withFiles wageFiles: [WageFile]? = nil) -> [String:Int] {
        let files = wageFiles == nil ? wageFileLoader.wageFiles : wageFiles!
        var localAllAverages: [String:Int] = [:]
        for instrument in Instrument.allCases {
            print(instrument.rawValue)
            let instrumentName = instrument.rawValue
            // Calculate the sum of instrument in loop
            let sum = files
                .compactMap { $0.gigType == gigType && $0.instrument == instrument ? $0.wage : nil }
                .reduce(0, { $0 + $1 })
            print(sum)
            // Calculate number of instrument entries
            let numberOfEntries = files.compactMap({$0.instrument == instrument ? instrument : nil}).count
            print(numberOfEntries)
            localAllAverages[instrumentName] = sum / (numberOfEntries == 0 ? 1 : numberOfEntries)
        }
        print("returning")
        return localAllAverages
    }
}
