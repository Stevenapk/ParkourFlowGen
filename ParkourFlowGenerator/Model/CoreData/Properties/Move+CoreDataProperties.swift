//
//  Move+CoreDataProperties.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//
//

import Foundation
import CoreData


extension Move {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Move> {
        return NSFetchRequest<Move>(entityName: "Move")
    }
    
    // MARK: - Properties

    @NSManaged public var id: UUID
    @NSManaged public var about: String
    @NSManaged public var name: String
    @NSManaged public var isEnabled: Bool
    @NSManaged public var linkString: String
    @NSManaged public var category: Category

}

// MARK: - Computed Properties

extension Move {
    var descriptionOrPlaceholder: String {
        if !about.isEmpty {
            return about
        } else {
            return "A move in the \(category.name.lowercased()) category."
        }
    }
    
    var defaultLinkString: String {
        let formattedName = name.replacingOccurrences(of: " ", with: "+")
        let formattedCatName = category.name.replacingOccurrences(of: " ", with: "+")
        
        return "https://www.youtube.com/results?search_query=\(formattedName)+\(formattedCatName)"
    }
}

// MARK: Identifiable

extension Move : Identifiable {
    
    static func == (lhs: Move, rhs: Move) -> Bool {
        // Compare id for equality
        return lhs.id == rhs.id
    }
}

// MARK: - Functions

extension Move {
    func swapForDifferentMoveInCategory() -> Move {
        let newApplicableMoves = category.applicableMoves.filter {$0 != self}
        return newApplicableMoves.randomElement() ?? DataManager.shared.allEnabledMoves[0]
    }
}
