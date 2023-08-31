//
//  zehnApp.swift
//  zehn
//
//  Created by Nikhilkumar Jadhav on 8/25/23.
//

import SwiftUI

@main
struct zehnApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
