//
//  MockDependencies.swift
//  Wage
//
//  Created by Patrick Rugebregt on 14/03/2022.
//

import Foundation

class MockDependencies:     HasNetwork,
                        HasWageFileLoader,
                        HasUserCreator,
                        HasFiltering,
                        HasWageFileManageable
{
    
    private var wageFileLoader: WageFileLoader!
    private var filtering: Filtering!
    private var networkDownload = NetworkDownload()
    private var userCreator: UserCreator = UserCreator()
    private var wageFiles: WageFiles!
    
    init() {
        wageFileLoader = WageFileLoader(dependencies: self)
        self.filtering = Filtering(dependencies: self)
        self.wageFiles = WageFiles(dependencies: self)
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
    
    func injectWageFileManageable() -> WageFileManageable {
        wageFiles
    }
    
}
