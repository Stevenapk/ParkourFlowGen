//
//  Category+CoreDataProperties.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//
//

import Foundation
import CoreData
import SwiftUI


extension Category {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var isEnabled: Bool
    @NSManaged public var moves: NSSet?
    
}

// MARK: Generated accessors for move
extension Category {
    
    @objc(addMoveObject:)
    @NSManaged public func addToMove(_ value: Move)
    
    @objc(removeMoveObject:)
    @NSManaged public func removeFromMove(_ value: Move)
    
    @objc(addMove:)
    @NSManaged public func addToMove(_ values: NSSet)
    
    @objc(removeMove:)
    @NSManaged public func removeFromMove(_ values: NSSet)
    
}

// MARK: - Computed Properties

extension Category {
    
    //    var applicableMoves: [Move] {
    //        if let moves {
    //            guard let unsortedMovesArray = moves.allObjects as? [Move] else { return [] }
    //            return unsortedMovesArray.sorted { $0.name < $1.name }
    //        }
    //        return []
    //    }
    
    var applicableMoves: [Move] {
        
        // Create array of moves from NSSet of related moves
        guard let moves, var movesArray = moves.allObjects as? [Move] else { return [] }
        
        // Remove all elements from movesArray that are not enabled
        movesArray.removeAll(where: {$0.isEnabled == false})
        
        // Sort alphabetically
        movesArray = movesArray.sorted {$0.name.capitalized < $1.name.capitalized}
        
        // Return final array
        return movesArray
    }
    
    var allMoves: [Move] {
        
        // Create Array of moves from NSSet of related moves
        guard let moves, var movesArray = moves.allObjects as? [Move] else { return [] }
        
        // Sort alphabetically
        movesArray = movesArray.sorted {$0.name.capitalized < $1.name.capitalized}
        
        // Return final array
        return movesArray
    }
    
//    var color: Color {
//        // Extract the first three digits of the UUID
//        let uuidString = id.uuidString
//        let startIndex = uuidString.startIndex
//        let endIndex = uuidString.index(startIndex, offsetBy: 2)
//        let substring = uuidString[startIndex...endIndex]
//
//        // Convert the substring to a numeric value (UInt8)
//        if let intValue = UInt8(substring, radix: 16) {
//            // Normalize the value to be in the range [0, 255]
//            let normalizedValue = CGFloat(intValue) / 255.0
//
//            // Create a color with RGB values from the normalized value
//            return Color(red: Double(normalizedValue),
//                         green: Double(normalizedValue),
//                         blue: Double(normalizedValue))
//        }
//
//        // Return a default color if conversion fails
//        return Color.gray
//    }
    
//    var color: Color {
//
//        let uiColor: UIColor
//
//        let firstLetter: Character = name.uppercased().first!
//
//        if firstLetter.isLetter && name.count > 2 {
//
//            let firstLetterValue: Int = Int(firstLetter.asciiValue!)
//
//            let secondLetterValue: Int = Int(Character(String((name.uppercased().prefix(2).dropFirst()))).asciiValue!)
//
//            let thirdLetterValue: Int = Int(Character(String((name.uppercased().prefix(3).dropFirst().dropFirst()))).asciiValue!)
//
//            let lastLetterValue: Int = Int(Character(String((name.uppercased().last!))).asciiValue!)
//
//            let red = Double(thirdLetterValue-65)/26.0
//            let green = Double(secondLetterValue-65)/26.0
//            let blue = Double(firstLetterValue-65)/26.0
//
//            // Create a color with RGB values from the normalized value
//                        let colorToReturn = Color(red: red,
//                                     green: green,
//                                     blue: blue)
//
//            return colorToReturn
//
//            let index = ((firstLetterValue + secondLetterValue + thirdLetterValue + lastLetterValue)/4) * 4 - Int(Character("A").asciiValue!)
//            let brightness: CGFloat = UITraitCollection.current.userInterfaceStyle == .dark ? 1.0 : 0.5
//            uiColor = UIColor(hue: CGFloat(index) / 26.0, saturation: 0.8, brightness: brightness, alpha: 1.0)
//
//        } else {
//            return Color.gray
//        }
//        return Color(uiColor)
//    }
    
    var color: Color {
        
        let uiColor: UIColor
        
        switch name {
        case "Bar Tricks":
                uiColor = #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1)
        case "Breakdancing":
            uiColor = #colorLiteral(red: 0.3158665899, green: 0.3153544472, blue: 1, alpha: 1)
        case "Dismount Tricks":
            uiColor = #colorLiteral(red: 0, green: 1, blue: 0.3293940282, alpha: 1)
        case "Flips":
            uiColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        case "Flow Moves":
            uiColor = #colorLiteral(red: 1, green: 0.3338502113, blue: 0, alpha: 1)
        case "Modifiers":
            uiColor = #colorLiteral(red: 0.5096153846, green: 0.01923076923, blue: 1, alpha: 1)
        case "Parkour":
            uiColor = #colorLiteral(red: 1, green: 0.9488220363, blue: 0, alpha: 1)
        case "Tricking":
            uiColor = #colorLiteral(red: 1, green: 0, blue: 0.6574504828, alpha: 1)
        case "Vaults":
            uiColor = #colorLiteral(red: 0.0002536039546, green: 0.6117460794, blue: 1, alpha: 1)
        case "Wall Tricks":
            uiColor = #colorLiteral(red: 0, green: 0.3687502725, blue: 1, alpha: 1)
        default:

            let firstLetter: Character = name.lowercased().first!

            if firstLetter.isLetter && name.count > 2 {

                let firstLetterValue: Int = Int(firstLetter.asciiValue!)

                let secondLetterValue: Int = Int(Character(String((name.lowercased().prefix(2).dropFirst()))).asciiValue!)

                let thirdLetterValue: Int = Int(Character(String((name.lowercased().prefix(3).dropFirst().dropFirst()))).asciiValue!)

                let index = ((firstLetterValue + secondLetterValue + thirdLetterValue)/3) * 3 - Int(Character("A").asciiValue!)
                let brightness: CGFloat = UITraitCollection.current.userInterfaceStyle == .dark ? 1.0 : 0.5
                uiColor = UIColor(hue: CGFloat(index) / 26.0, saturation: 0.8, brightness: brightness, alpha: 1.0)

            } else {
                return Color.gray
            }
        }
        return Color(uiColor)
    }
    
    var darkColor: Color {
        
        let uiColor: UIColor
        
        let firstLetter: Character = name.lowercased().first!
        
        if firstLetter.isLetter && name.count > 2 {
            
            let firstLetterValue: Int = Int(firstLetter.asciiValue!)
            
            let secondLetterValue: Int = Int(Character(String((name.lowercased().prefix(2).dropFirst()))).asciiValue!)

            let thirdLetterValue: Int = Int(Character(String((name.lowercased().prefix(3).dropFirst().dropFirst()))).asciiValue!)

            let index = ((firstLetterValue + secondLetterValue + thirdLetterValue)/3) * 3 - Int(Character("A").asciiValue!)
            uiColor = UIColor(hue: CGFloat(index) / 26.0, saturation: 0.8, brightness: 0.7, alpha: 1.0)
            
        } else {
            return Color.gray
        }
        return Color(uiColor)
    }
    
}

// MARK: - Identifiable

extension Category : Identifiable {
    
    // Implement the == operator for equality comparison
    static func == (lhs: Category, rhs: Category) -> Bool {
        // Compare id for equality
        return lhs.id == rhs.id
    }
    
    // Implement the hash(into:) method
//    func hash(into hasher: inout Hasher) {
//        // Combine hash values of all properties
//        hasher.combine(id)
//        hasher.combine(name)
//        hasher.combine(isEnabled)
//        // Combine hash values of other properties
//    }
    
}

// MARK: - Functions

extension Category {
    
    func randomApplicableMove() -> Move {
       applicableMoves.randomElement()!
    }
    
}
