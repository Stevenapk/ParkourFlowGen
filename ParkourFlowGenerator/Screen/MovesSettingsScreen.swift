//
//  MovesSettingsScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/27/23.
//

import SwiftUI

struct MovesSettingsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var moves: [Move]
    @Binding var refreshID: UUID
    
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
                        for move in moves {
                            move.isEnabled = true
                        }
                        PersistenceController.shared.saveContext()
                        refreshID = UUID()
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
                        for move in moves {
                            move.isEnabled = false
                        }
                        PersistenceController.shared.saveContext()
                        refreshID = UUID()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Moves Settings", displayMode: .inline)
        }
    }
}
//struct MovesSettingsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        MovesSettingsScreen()
//    }
//}
