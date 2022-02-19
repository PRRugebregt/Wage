//
//  AverageCalculator.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import Foundation

class AverageCalculator {
    
    var wageFiles: [WageFile] = [] {
        didSet {
            calculateValues()
        }
    }
    
    var averageFee: Int = 0
    var averageExperience: Int = 0
    var averageGigType: GigType = .anders
    var averageInstrument: Instrument = .Anders
    
    private func calculateValues() {
        averageFee = calculateFee()
        averageGigType = calculateGigType()
        averageExperience = calculateYears()
        averageInstrument = calculateInstrument()
    }
    
    private func calculateFee() -> Int {
        guard wageFiles.count > 0 else { return 0 }
        var sum: Int = 0
        for file in wageFiles {
            sum += file.wage
        }
        sum = sum / wageFiles.count
        return sum
    }
    
    private func calculateGigType() -> GigType {
        guard wageFiles.count > 0 else { return .anders}
        var counts = [GigType]()
        for file in wageFiles {
            counts.append(file.gigType)
        }
        let freq = counts.frequency
        let maxVal = freq.values.max()
        var mostGigged: GigType?
        for f in freq {
            if f.value == maxVal {
                mostGigged = f.key
            }
        }
        return mostGigged!
    }
    
    private func calculateYears() -> Int {
        guard wageFiles.count > 0 else { return 0 }
        var sum: Int = 0
        for file in wageFiles {
            sum += file.yearsOfExperience
        }
        sum = sum / wageFiles.count
        return sum
    }
    
    private func calculateInstrument() -> Instrument {
        guard wageFiles.count > 0 else { return .Anders}
        var counts = [Instrument]()
        for file in wageFiles {
            counts.append(file.instrument)
        }
        let freq = counts.frequency
        let maxVal = freq.values.max()
        var mostGigged: Instrument?
        for f in freq {
            if f.value == maxVal {
                mostGigged = f.key
            }
        }
        return mostGigged!
    }
    
    
    
}
