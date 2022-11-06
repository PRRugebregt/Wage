//
//  AverageCalculator.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import Foundation

class AverageCalculator {
    
    var wageFiles = [WageFile]() {
        didSet {
            calculateValues()
        }
    }
    
    var averageWage = 0
    var averageExperience = 0
    var averageGigType: GigType = .anders
    var averageInstrument: Instrument = .Anders
    
    private func calculateValues() {
        averageWage = calculateWage()
        averageGigType = calculateGigType()
        averageExperience = calculateYears()
        averageInstrument = calculateInstrument()
    }
    
    /// Calculate the average wage
    private func calculateWage() -> Int {
        guard wageFiles.count > 0 else { return 0 }
        // Add all wages and divide by number of wages
        let sum: Int = wageFiles.reduce(0, {$0 + $1.wage}) / wageFiles.count
        return sum
    }
    
    /// Calculate the most common gigType
    private func calculateGigType() -> GigType {
        guard wageFiles.count > 0 else { return .anders }
        
        let allGigTypes = wageFiles.map { $0.gigType }
        let frequencyPerGigType = allGigTypes.frequency
        let maxValue = frequencyPerGigType.values.max()
        guard let averageGigType = frequencyPerGigType.first(where: {$0.value == maxValue}) else {
            return .anders
        }
        
        return averageGigType.key
    }
    
    /// Calculate the average years of experience
    private func calculateYears() -> Int {
        guard wageFiles.count > 0 else { return 0 }
        
        let sum = wageFiles.reduce(0, {$0 + $1.yearsOfExperience}) / wageFiles.count
        return sum
    }
    
    /// Calculate the most common instrument
    private func calculateInstrument() -> Instrument {
        guard wageFiles.count > 0 else { return .Anders }
        
        let allInstruments = wageFiles.map {$0.instrument}
        // Count instrument frequency and map to dictionary
        let frequencyPerInstrument = allInstruments.frequency
        let maxValue = frequencyPerInstrument.values.max()
        // Fetch the instrument with highest count
        guard let averageInstrument = frequencyPerInstrument.first(where: {$0.value == maxValue}) else {
            return .Anders
        }
        
        return averageInstrument.key
    }
}
