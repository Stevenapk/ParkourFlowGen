//
//  DataManager.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//

import Foundation
import CoreData

import SwiftUI

final class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
//    var categories: [Category] {
//        do {
//            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//            return try Constants.context.fetch(fetchRequest)
//        } catch {
//            return []
//        }
//    }
    
    init() {
        do {
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isEnabled == %@", NSNumber(value: true))
            categories = try Constants.context.fetch(fetchRequest)
        } catch {
            categories = []
        }
    }
    
    @Published var categories: [Category]
    
    
    var enabledCategories: [Category] {
        do {
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isEnabled == %@", NSNumber(value: true))
            return try Constants.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    
//    var enabledCategories: [Category] {
//        categories.filter({$0.isEnabled})
//    }
    
//    var allEnabledMoves: [Move] {
//        var movesToReturn: [Move] = []
//        for category in enabledCategories {
//            for move in category.applicableMoves {
//                movesToReturn.append(move)
//            }
//        }
//        return movesToReturn
//    }
    
    var allEnabledMoves: [Move] {
        do {
            let fetchRequest: NSFetchRequest<Move> = Move.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isEnabled == %@", NSNumber(value: true))
            return try Constants.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    //TODO: when have connection, add predicate to this for isEnabled and consider using it to replace the var above :)
//    @FetchRequest(
//        entity: Move.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Move.name, ascending: true)]
//    ) var allEnabledMoves: FetchedResults<Move>
    
//    var allMoveNames: [String] {
//        var moveNamesToReturn: [String] = []
//        for category in categories {
//            for move in category.allMoves {
//                moveNamesToReturn.append(move.name)
//            }
//        }
//        return moveNamesToReturn
//    }
    
    var allMoveNames: [String] {
        do {
            let fetchRequest: NSFetchRequest<Move> = Move.fetchRequest()
            return try Constants.context.fetch(fetchRequest).map {$0.name}
        } catch {
            return []
        }
    }
    

    // MARK: - equation to generate a random combo of moves base on combo length

    func generateRandomCombo(length: Int) -> [Move] {
        
        // Define moves to return
        var movesToReturn: [Move] = []
        
        // Define moves to choose from so they aren’t repeatedly computed from a getter
        let movesToChooseFrom = allEnabledMoves
        // Ensure there are moves present to choose from, if not, return empty array
        guard !movesToChooseFrom.isEmpty else { return [] }
        
        // Choose random moves from the applicable moves list and add them to the array for each unit in length the user has specified
        for _ in 0..<length {
            movesToReturn.append(movesToChooseFrom.randomElement()!)
        }
        return movesToReturn
    }

    // MARK: - Equation for generated a specific line order
    // Before the function below is called, ensure that categories aren’t allowed to be selected for the line if they have 0 applicable moves (different than 0 moves total, applicable specifically ☺️)
    
    func generateRandomMovesInSpecificLine(categoryOrder: [CategoryWithTempID]) -> [Move] {
        
        // Define empty array of moves to return
        var movesToReturn = [Move]()
        
        // Add a random move in the line for each category in the specified order
        for category in categoryOrder {
            
            // Define applicable moves so they aren’t repeatedly computed from a getter
            let applicableMoves = category.category.applicableMoves
            
            // Ensure applicable moves is not empty for this category, else do not add one
            guard !applicableMoves.isEmpty else { break }
            
            // Append a random applicable move from the category
            movesToReturn.append(applicableMoves.randomElement()!)
        }
        return movesToReturn
    }
    
    func mockGeneratedRandomMoves(comboLength: Int) -> [MockMove] {
        var movesToReturn = [MockMove]()
        for _ in 0..<comboLength {
            movesToReturn.append(MockMove())
        }
        return movesToReturn
    }
    
    func openYoutubeLink(from move: Move) {
        if let url = URL(string: !move.linkString.isEmpty ? move.linkString : move.defaultLinkString) {
            UIApplication.shared.open(url)
        }
    }
    
//    func mockGeneratedandomMovesInSpecificLine(categoryOrder: [CategoryWithTempID]) -> [MockMove] {
//        
//        // Define empty array of moves to return
//        var movesToReturn = [MockMove]()
//        
//        // Add a random move in the line for each category in the specified order
//        for category in categoryOrder {
//            
//            // Define applicable moves so they aren’t repeatedly computed from a getter
//            let applicableMoves = category.category.applicableMoves
//            
//            if applicableMoves.isEmpty {
//                movesToReturn.append([MockMove(name: "double backflip"), MockMove(name: "cartahara"), MockMove(name: "helicoptero in full out")].randomElement()!)
//            }
//            
//            // Ensure applicable moves is not empty for this category, else do not add one
//            if !applicableMoves.isEmpty {
//                
//                // Append a random applicable move from the category
//                movesToReturn.append(applicableMoves.randomElement()!)
//            }
//        }
//        return movesToReturn
//    }
    
    var mockCategories = [
        MockCat(name: "Flips", applicableMoves: [MockMove(name: "gainer"), MockMove(name: "aerial")]),
        MockCat(name: "Tricking", applicableMoves: [MockMove(name: "cork"), MockMove(name: "b-twist")]),
        MockCat(name: "Dismount tricks", applicableMoves: [MockMove(name: "roll bomb"), MockMove(name: "jump and roll")]),
        MockCat(name: "Wall trick", applicableMoves: [MockMove(name: "wallflip"), MockMove(name: "down monkey")]),
        MockCat(name: "Vaults", applicableMoves: [MockMove(name: "kash vault"), MockMove(name: "roll kip up vault"), MockMove(name: "kong gainer")]),
        MockCat(name: "Bar tricks", applicableMoves: [MockMove(name: "flyaway"), MockMove(name: "swing dive roll")]),
        MockCat(name: "Breakdancing", applicableMoves: [MockMove(name: "windmill"), MockMove(name: "flare")]),
        MockCat(name: "Flow", applicableMoves: [MockMove(name: "cartwheel"), MockMove(name: "butt spin")])
    ]

    var mockMoves: [MockMove] {
        mockCategories.map {$0.applicableMoves}.flatMap {$0}
    }
    
}

// MARK: - Generate Defaults

extension DataManager {
    
    func generateDefaultsIfNeeded(completion: @escaping () -> Void) {
        
        if shouldGenerateDefaults() {
            let defaultsDataManager = DefaultsDataManager()
            generateDefaults(defaultsDataManager: defaultsDataManager) {
                completion()
            }
        }
    }
    
    func hasAppBeenOpenedBefore() -> Bool {
        do {
            let fetchRequest: NSFetchRequest<AppStatus> = AppStatus.fetchRequest()
            let status = try Constants.context.fetch(fetchRequest)
            if status.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            return false
        }
    }
    
    func shouldGenerateDefaults() -> Bool {
        do {
            let fetchRequest: NSFetchRequest<AppStatus> = AppStatus.fetchRequest()
            let status = try Constants.context.fetch(fetchRequest)
            if status.isEmpty {
                print("NO STATUS")
                generateAppStatus()
                PersistenceController.shared.saveContext()
                return true
            } else {
                print("STATUS PRESENT")
                return false
            }
        } catch {
            print("CATCH STATUS")
            generateAppStatus()
            PersistenceController.shared.saveContext()
            return true
        }
        
        func generateAppStatus() {
            let newStatus = AppStatus(context: Constants.context)
            newStatus.isReturning = true
        }
    }
    
    func setAppStatus() {
        do {
            let fetchRequest: NSFetchRequest<AppStatus> = AppStatus.fetchRequest()
            let status = try Constants.context.fetch(fetchRequest)
            if status.isEmpty {
                generateAppStatus()
                PersistenceController.shared.saveContext()
            } else {
                status.first!.isReturning = true
                PersistenceController.shared.saveContext()
            }
        } catch {
            generateAppStatus()
            PersistenceController.shared.saveContext()
        }
        
        func generateAppStatus() {
            let newStatus = AppStatus(context: Constants.context)
            newStatus.isReturning = true
        }
    }
    
    func generateDefaults(defaultsDataManager: DefaultsDataManager, completion: @escaping () -> Void) {
        
        let parkour = Category(context: Constants.context)
        parkour.name = "Parkour"
        let flips = Category(context: Constants.context)
        flips.name = "Flips"
        let flowMoves = Category(context: Constants.context)
        flowMoves.name = "Flow Moves"
        let dismountTricks = Category(context: Constants.context)
        dismountTricks.name = "Dismount Tricks"
        let wallTricks = Category(context: Constants.context)
        wallTricks.name = "Wall Tricks"
        let barTricks = Category(context: Constants.context)
        barTricks.name = "Bar Tricks"
        let tricking = Category(context: Constants.context)
        tricking.name = "Tricking"
        let breakdancing = Category(context: Constants.context)
        breakdancing.name = "Breakdancing"
        let vaults = Category(context: Constants.context)
        vaults.name = "Vaults"
        let modifiers = Category(context: Constants.context)
        modifiers.name = "Modifiers"
        modifiers.isEnabled = false
        
        for data in defaultsDataManager.parkour {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = parkour
        }
        
        for data in defaultsDataManager.flips {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = flips
        }
        
        for data in defaultsDataManager.flowMoves {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = flowMoves
        }
        
        for data in defaultsDataManager.dismountTricks {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = dismountTricks
        }
        
        for data in defaultsDataManager.wallTricks {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = wallTricks
        }
        
        for data in defaultsDataManager.barTricks {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = barTricks
        }
        
        for data in defaultsDataManager.tricking {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = tricking
        }
        
        for data in defaultsDataManager.breakdancing {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = breakdancing
        }
        
        for data in defaultsDataManager.vaults {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = vaults
        }
        
        for data in defaultsDataManager.modifiers {
            let move = Move(context: Constants.context)
            move.name = data.name.capitalized
            move.about = data.about
            move.linkString = data.linkString
            move.category = modifiers
        }
        
        PersistenceController.shared.saveContext()
        completion()
    
    }
}
