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
    private static let dependencies = Dependencies()
    @StateObject private var wageFileLoader = WageFileLoader(dependencies: dependencies)
    @StateObject private var filtering = Filtering(dependencies: dependencies)
    @StateObject private var userCreator: UserCreator = UserCreator()
    private var networkDownload = NetworkDownload()
    private var wageFiles: WageFiles = WageFiles(dependencies: dependencies)
    
    init() {
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
