//
//  AppStatus+CoreDataProperties.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//
//

import Foundation
import CoreData


extension AppStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppStatus> {
        return NSFetchRequest<AppStatus>(entityName: "AppStatus")
    }

    @NSManaged public var isReturning: Bool

}

extension AppStatus : Identifiable {

}
