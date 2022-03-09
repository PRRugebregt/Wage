//
//  DependencyRouter.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import Foundation

class Dependencies {
    
    private let networkDownload = NetworkDownload()
    private let wageFileLoader = WageFileLoader()
    private let userCreator = UserCreator()
    private let wageFiles: WageFiles
    private let filtering: Filtering
    
    init() {
        self.wageFiles = WageFiles(networkDownload: networkDownload)
        self.wageFileLoader.wageFileManageable = wageFiles
        self.wageFileLoader.networkDownload = networkDownload
        self.filtering = Filtering(wageFileLoader: wageFileLoader)
        PersistenceController.shared.setWageFileManageable(wageFiles) 
    }
    
    deinit {
        print("Deinit on dependency router")
    }
    
    func injectNetwork() -> NetworkDownload {
        networkDownload
    }
    
    func injectWageFileLoader() -> WageFileLoader {
        print("called")
        return wageFileLoader
    }
    
    func injectUserCreator() -> UserCreator {
        userCreator
    }
    
    func injectFiltering() -> Filtering {
        filtering
    }
    
}
