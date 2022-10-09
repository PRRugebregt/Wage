//
//  WageApp.swift
//  Wage
//
//  Created by Patrick Rugebregt on 10/02/2022.
//

import SwiftUI
import Firebase

@main
struct WageApp: App {
    
    let persistenceController = PersistenceController.shared
    let dependencies: Dependencies
    
    init() {
        FirebaseApp.configure()
        self.dependencies = Dependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(wageFileLoader: dependencies.injectWageFileLoader(), dependencies: dependencies)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
