//
//  Constants.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//

import Foundation
import CoreData
import CloudKit

class Constants {
    // CloudKit / Core Data Persistent Container
    lazy var persistentContainer: NSPersistentCloudKitContainer = PersistenceController.shared.container
    // Core Data Context
    static let context = PersistenceController.shared.container.viewContext
//    static let backgroundColor = Color(uiColor: #colorLiteral(red: 0.08319245926, green: 0.08319245926, blue: 0.08319245926, alpha: 0.8470588235))
}
