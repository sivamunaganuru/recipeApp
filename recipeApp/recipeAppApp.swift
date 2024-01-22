//
//  recipeAppApp.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/19/24.
//

import SwiftUI
import CoreData


@main
struct recipeAppApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
