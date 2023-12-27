//
//  ParkourFlowGeneratorApp.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/15/23.
//

import SwiftUI
import CoreData
import CloudKit

@main
struct ParkourFlowGeneratorApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.colorScheme, .dark)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = PersistenceController.shared.container
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Save core data changes before app termination
        PersistenceController.shared.saveContext()
    }
    
}
