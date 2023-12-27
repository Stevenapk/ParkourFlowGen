//
//  MovesChecklistScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//

import SwiftUI

struct MockMove: Identifiable, Equatable {
    var id = UUID()
    var name = ["backflip", "frontflip", "lazy vault", "kong vault", "butt spin", "cat cast", "kong frontflip", "safety webster"].randomElement()!
    var description = ""
    var linkString = ""
    var isEnabled: Bool = true
    var category: MockCat = MockCat()
    
    var descriptionOrPlaceholder: String {
        if !description.isEmpty {
            return description
        } else {
            return "A move in the \(realCategory.name.lowercased()) category."
        }
    }
    
    static func == (lhs: MockMove, rhs: MockMove) -> Bool {
        // Compare id for equality
        return lhs.id == rhs.id
    }
    
    var realCategory: MockCat {
        return DataManager.shared.mockCategories.first(where: {$0.applicableMoves.contains(where: {$0==self})}) ?? MockCat(name: "Unknown")
    }
    
    func swapForDifferentMoveInCategory() -> MockMove {
        let newApplicableMoves = realCategory.applicableMoves.filter {$0 != self}
        return newApplicableMoves.randomElement() ?? DataManager.shared.mockMoves[0]
    }
}

class MovesChecklistViewModel: ObservableObject {
//    init(moves: [MockMove], category: MockCat) {
//        self.moves = moves
//        self.category = category
//    }
//    @Published var moves: [MockMove]
//    @Published var category: MockCat
    
    init(category: Category) {
        self.moves = category.allMoves
        self.category = category
    }
    @Published var moves: [Move]
    @Published var category: Category
}

struct MovesChecklistScreen: View {
    
    @ObservedObject var vm: MovesChecklistViewModel
    @State var isShowingAddMoveScreen: Bool = false
    @State var isShowingMovesSettingScreen = false
    @State var refreshID: UUID = UUID()
    
    var body: some View {
            VStack {
//                Text(vm.moves[0].realCategory.name)
//                    .font(.title)
                List {
                    ForEach($vm.moves) { $move in
                        ChecklistRow(move: $move, category: $vm.category, refreshID: $refreshID)
                    }
                        .onMove(perform: move)
                        .onDelete(perform: deleteMove)
                    }
                    .toolbar {
                        Button {
                            HapticsManager.shared.mediumVibrate()
                            //present alert with name and description
                            isShowingAddMoveScreen.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        Button {
                            HapticsManager.shared.mediumVibrate()
                            //present alert with name and description
                            isShowingMovesSettingScreen.toggle()
                        } label: {
                            Image(systemName: "line.horizontal.3")
                        }
                    }
                    .navigationTitle(vm.category.name)
//                    .navigationBarTitle(vm.category.name, displayMode: .inline)
            }
            .sheet(isPresented: $isShowingAddMoveScreen) {
                AddEditMoveScreen(category: $vm.category)
            }
            .sheet(isPresented: $isShowingMovesSettingScreen) {
                MovesSettingsScreen(moves: $vm.moves, refreshID: $refreshID)
            }
            .onDisappear {
                PersistenceController.shared.saveContext()
            }
//            .background(Constants.backgroundColor)
            //        .onAppear {
            //            vm.moves[1].isEnabled = false
            //        }
        
    }
//    func addMove() {
//        categories.append(MockCat(name: name, description: description))
//    }
    
//    func editMove() {
//        let index = categories.firstIndex(where: {$0==categoryToEdit})!
//        categories[index].name = name
//    }
    
    func move(from source: IndexSet, to destination: Int) {
        vm.moves.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteMove(at offsets: IndexSet) {
        for index in offsets {
                
                let moveToDelete = vm.moves[index]
                
                // Delay delete to ensure smooth prior animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        Constants.context.delete(moveToDelete)
                }
        }
    }
}

//struct MovesChecklistScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MovesChecklistScreen(vm: MovesChecklistViewModel(moves: DataManager.shared.mockCategories[2].applicableMoves, category: DataManager.shared.mockCategories[2]))
//        }
//    }
//}

struct ChecklistRow: View {
    
//    @State var moveToEdit: MockMove?
//    @Binding var move: MockMove
//    @Binding var category: MockCat
    @State var moveToEdit: Move?
    @Binding var move: Move
    @Binding var category: Category
//    @State var refreshID: UUID = UUID()
    @Binding var refreshID: UUID
    
    @State var shouldShowEditScreen = false
    
    func triggerEditMove() {
        HapticsManager.shared.mediumVibrate()
        shouldShowEditScreen = true
        moveToEdit = move
    }
    
    var body: some View {
        HStack {
            Image(systemName: move.isEnabled ? "checkmark.square.fill" : "square")
                .foregroundColor(move.isEnabled ? .primary : .gray)
                .font(Font.title)
                .lineLimit(1)
                .onTapGesture {
                    HapticsManager.shared.vibrate(for: .success)
//                    withAnimation(.easeInOut) {
                        move.isEnabled.toggle()
                        PersistenceController.shared.saveContext()
                        refreshID = UUID()
//                    }
                }

                Text(move.name.capitalized)
                    .foregroundColor(move.isEnabled ? .primary : .gray)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Rectangle().foregroundColor(Color(uiColor: .secondarySystemBackground)))

//            .onLongPressGesture(minimumDuration: 0.5) {
//                    //                                            HapticsManager.shared.mediumVibrate()
//                    //                                            shouldShowEditScreen = true
//                    //                                            moveToEdit = move
//                    //                    updateCategoryToEdit(category) {
//                    //                        isShowingEditCategoryAlert.toggle()
//                    //                    }
//            }
                Image(systemName: "pencil")
                .foregroundColor(move.isEnabled ? .primary : .gray)
                .onTapGesture {
                    triggerEditMove()
                }
//            Spacer()
        }
        .id(refreshID)
        .onTapGesture {
            shouldShowEditScreen = false
            moveToEdit = move
        }
        .sheet(item: $moveToEdit) { move in
            if shouldShowEditScreen {
                AddEditMoveScreen(moveToEdit: move, category: $category, namePlaceholder: move.name)
            } else {
                ViewMoveDetailsScreen(move: move)
            }
        }
//        .onTapGesture {
//            move.isEnabled.toggle()
//        }
    }
}

//struct ChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChecklistView()
//    }
//}
