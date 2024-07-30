//
//  ShadiDotComAssignmentApp.swift
//  ShadiDotComAssignment
//
//  Created by Anubhav Singh on 29/07/24.
//

import SwiftUI

@main
struct ShadiDotComAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
