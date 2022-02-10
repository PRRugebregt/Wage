//
//  WageApp.swift
//  Wage
//
//  Created by Patrick Rugebregt on 10/02/2022.
//

import SwiftUI

@main
struct WageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
