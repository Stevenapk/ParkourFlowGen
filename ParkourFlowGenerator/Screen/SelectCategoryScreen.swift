//
//  SelectCategoryScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/18/23.
//

import SwiftUI

struct SelectCategoryScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    //    @Binding var combo: [MockMove]
    @Binding var combo: [Move]
    var index: Int
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) var categories: FetchedResults<Category>
    
    var isCategorySwap: Bool {
        index != -1
    }
    
    var body: some View {
        VStack {
            List(categories) { category in
                
                HStack {
                    Text(category.name)
                    Rectangle()
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .opacity(0.1)
                }
                .onTapGesture {
                    if isCategorySwap {
                        combo[index] = category.randomApplicableMove()
                    } else {
                        combo.append(category.randomApplicableMove())
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

//struct SelectCategoryScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create an array of MockMove instances for preview
//        var mockMoves = DataManager.shared.mockCategories[0].applicableMoves
//        
//        // Create a binding to the array of MockMove instances
//        let binding = Binding<[MockMove]>(
//            get: { mockMoves },
//            set: { newValue in mockMoves = newValue }
//        )
//        SelectCategoryScreen(combo: binding, index: -1)
//    }
//}
