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

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            UserView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
