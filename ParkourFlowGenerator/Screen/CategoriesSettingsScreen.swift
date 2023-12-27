//
//  CategoriesSettingsScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/27/23.
//

import SwiftUI

struct CategoriesSettingsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var categories: [Category]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Text("Check all")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Rectangle().foregroundColor(Color(uiColor: .secondarySystemBackground)))
                        Image(systemName: "checkmark.square")
                    }
                    .foregroundColor(.green)
                    .onTapGesture {
                        for category in categories {
                            category.isEnabled = true
                        }
                        PersistenceController.shared.saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    HStack {
                        Text("Uncheck all")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Rectangle().foregroundColor(Color(uiColor: .secondarySystemBackground)))
                        Image(systemName: "square")
                    }
                    .foregroundColor(.red)
                    .onTapGesture {
                        for category in categories {
                            category.isEnabled = false
                        }
                        PersistenceController.shared.saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    HStack {
                        Text("Reset to defaults")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Rectangle().foregroundColor(Color(uiColor: .secondarySystemBackground)))
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .foregroundColor(.blue)
                    .onTapGesture {
                        HapticsManager.shared.selectionVibrate()
                        deleteAllCategories()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                            DataManager.shared.generateDefaults(defaultsDataManager: DefaultsDataManager()) {
                                PersistenceController.shared.saveContext()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    
                    HStack {
                        Text("Add defaults to current categories.")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Rectangle().foregroundColor(Color(uiColor: .secondarySystemBackground)))
                        Image(systemName: "plus.circle")
                    }
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        HapticsManager.shared.selectionVibrate()
                        DataManager.shared.generateDefaults(defaultsDataManager: DefaultsDataManager()) {
                            PersistenceController.shared.saveContext()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Category Settings", displayMode: .inline)
        }
    }
    
    func deleteAllCategories() {
        
        let categoriesToDelete = categories
        
        categories = []
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            for category in categoriesToDelete {
                Constants.context.delete(category)
            }
        }
    }
}

//struct CategoriesSettingsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesSettingsScreen()
//    }
//}
