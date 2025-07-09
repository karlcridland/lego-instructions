//
//  Lego_InstructionsApp.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI

@main
struct Lego_InstructionsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
