//
//  DependencyRouter.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import Foundation

class DependencyRouter {
    
    private let wageFileLoader: WageFileLoader
    private let wageFiles: WageFiles
    
    init(wageFileLoader: WageFileLoader) {
        self.wageFiles = WageFiles()
        self.wageFileLoader = wageFileLoader
        self.wageFileLoader.wageFileManageable = wageFiles
        PersistenceController.shared.setWageFileManageable(wageFiles) 
    }
    
}
