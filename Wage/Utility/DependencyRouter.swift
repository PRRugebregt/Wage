//
//  DependencyRouter.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import Foundation
import SwiftUI

protocol HasNetwork {
    func injectNetwork() -> NetworkDownload
}

protocol HasWageFileLoader {
    func injectWageFileLoader() -> WageFileLoader
}

protocol HasUserCreator {
    func injectUserCreator() -> UserCreator
}

protocol HasFiltering {
    func injectFiltering() -> Filtering
}

protocol HasWageFileManageable {
    func injectWageFileManageable() -> WageFileManageable
}

class Dependencies:     HasNetwork,
                        HasWageFileLoader,
                        HasUserCreator,
                        HasFiltering,
                        HasWageFileManageable {
    private var wageFileLoader: WageFileLoader!
    private var filtering: Filtering!
    private var userCreator: UserCreator = UserCreator()
    private var networkDownload = NetworkDownload()
    private var wageFiles: WageFiles!
    
    init() {
        self.wageFileLoader = WageFileLoader(dependencies: self)
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
        print("called inject wagefileloader?? ")
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
