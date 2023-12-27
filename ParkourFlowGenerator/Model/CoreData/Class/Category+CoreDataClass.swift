//
//  Category+CoreDataClass.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setDefaults()
    }
    func setDefaults() {
        //set to random new UUID
        self.id = UUID()
    }
}
