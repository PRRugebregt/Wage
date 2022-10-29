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
        self.wageFiles = WageFiles(dependencies: self)
        self.wageFileLoader = WageFileLoader(dependencies: self)
        self.filtering = Filtering(dependencies: self)
    }
    
    func injectNetwork() -> NetworkDownload {
        networkDownload
    }
    
    func injectWageFileLoader() -> WageFileLoader {
        wageFileLoader
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
