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
    
    init(wageFileLoader: WageFileLoader) {
        self.wageFileLoader = wageFileLoader
    }
    
    func loadResults(gigType: GigType) {
        allAverages = calculateAllAverages(for: gigType)
    }
    
    func calculateAllAverages(for gigType: GigType) -> [String:Int] {
        print(files.count)
        let files = wageFileLoader.onlineResults
        var localAllAverages: [String:Int] = [:]
        for instrument in Instrument.allCases {
            let instrumentName = instrument.rawValue
            var sum = 0
            var count = 0
            var average = 0
            for file in files {
                guard file.instrument == instrument, file.gigType == gigType else { continue }
                sum += file.wage
                count += 1
                print(sum)
            }
            average = count > 0 ? sum / count : 0
            localAllAverages[instrumentName] = average
        }
        return localAllAverages
    }
    
}
