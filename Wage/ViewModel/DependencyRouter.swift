//
//  DependencyRouter.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import Foundation

class DependencyRouter {
    
    private let networkDownload = NetworkDownload()
    private let wageFileLoader: WageFileLoader
    private let wageFiles: WageFiles
    
    init(wageFileLoader: WageFileLoader) {
        self.wageFiles = WageFiles(networkDownload: networkDownload)
        self.wageFileLoader = wageFileLoader
        self.wageFileLoader.wageFileManageable = wageFiles
        self.wageFileLoader.networkDownload = networkDownload
        PersistenceController.shared.setWageFileManageable(wageFiles) 
    }
    
}
