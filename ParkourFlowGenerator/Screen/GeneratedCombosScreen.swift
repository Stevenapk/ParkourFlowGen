//
//  GeneratedCombosScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/18/23.
//

import SwiftUI

// Extension to safely access elements in an array
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct GeneratedCombosScreen: View {
    
//    @State var combo: [MockMove]
    @State var combo: [Move]
    @State var isAbsoluteRandomGen: Bool = false
    
    var body: some View {
        ComboScrollView(combo: $combo, isAbsoluteRandomGen: $isAbsoluteRandomGen)
    }
}

struct IdentifiableInt: Identifiable {
    var id: Int
}

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension String {
   subscript(_ characterIndex: Int) -> Character {
      return self[index(startIndex, offsetBy: characterIndex)]
   }
}

struct GeneratedComboHeaderView: View {
    
    @Binding var verticalLayout: Bool
    @Binding var horizontalScrollViewRefreshID: UUID
    
    var body: some View {
        ZStack {
            Text("My Combo")
                .font(.title)
                .bold()
            HStack {
                Button {
                    HapticsManager.shared.mediumVibrate()
                    verticalLayout.toggle()
                    if !verticalLayout {
                        horizontalScrollViewRefreshID = UUID()
                    }
                } label: {
                    Image(systemName: verticalLayout ? "arrowtriangle.up" : "arrowtriangle.down.fill")
                        .font(.body)
                }
                .offset(x: 100)
                .padding(.trailing, 25)

            }
        }
    }
}

struct RectangleMoveSeparator: View {
    
    var index: Int
    @Binding var combo: [Move]
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Rectangle()
                    .frame(width: 5, height: 21)
                    .foregroundColor(index != combo.count-1 ? Color.primary : Color(uiColor: .systemBackground))
                //                            .padding(.bottom, -15)
            }
            Spacer()
        }
    }
}

struct GeneratedMoveLabel: View {
    
    var move: Move
    var isColorCoded: Bool
    
    var body: some View {
        VStack {
            Text(move.name.capitalized)
                .font(.title3)
                .bold()
                .padding(.vertical, 0)
                .padding(.horizontal, 70)
                .foregroundColor(isColorCoded ? move.category.color : .primary)
//                .foregroundColor(isColorCoded ? move.realCategory.color : .primary)
        }
    }
}

struct GeneratedComboList: View {
    
    @Binding var combo: [Move]
    @Binding var isColorCoded: Bool
    @Binding var isAbsoluteRandomGen: Bool
    
    @Binding var index: IdentifiableInt?
//    @State var verticalLayout = true
    @Binding var chosenMove: Move?
    @Binding var chosenIndex: Int
    
    var body: some View {
        List {
            ForEach(Array(zip(combo.indices, combo)), id: \.0) { index, move in
                VStack(alignment: .center) {
GeneratedMoveLabel(move: move, isColorCoded: isColorCoded)
                    .contextMenu {
                        if isAbsoluteRandomGen {
                            Button(action: {
                                //                                            let replacementMove = DataManager.shared.mockMoves.randomElement()!
                                let replacementMove = DataManager.shared.allEnabledMoves.randomElement()!
                                withAnimation {
                                    combo[index] = replacementMove
                                }
                            }) {
                                Text("Random move")
                                Image(systemName: "shuffle")
                            }
                            Button(action: {
                                //                                    let replacementMove = move.category.randomApplicableMove()
                                let replacementMove = move.swapForDifferentMoveInCategory()
                                withAnimation {
                                    combo[index] = replacementMove
                                }
                            }) {
                                Text("Refresh move")
                                Image(systemName: "arrow.counterclockwise")
                            }
                            Button {
                                self.index = IdentifiableInt(id: index)
                            } label: {
                                Text("Swap category")
                                Image(systemName: "arrow.2.squarepath")
                            }
                        } else {
                            Button(action: {
                                //                                    let replacementMove = move.category.randomApplicableMove()
                                let replacementMove = move.swapForDifferentMoveInCategory()
                                withAnimation {
                                    combo[index] = replacementMove
                                }
                            }) {
                                Text("Refresh move")
                                Image(systemName: "arrow.counterclockwise")
                            }
                            Button {
                                self.index = IdentifiableInt(id: index)
                            } label: {
                                Text("Swap category")
                                Image(systemName: "arrow.2.squarepath")
                            }
                            Button(action: {
                                //                                let replacementMove = DataManager.shared.mockMoves.randomElement()!
                                let replacementMove = DataManager.shared.allEnabledMoves.randomElement()!
                                withAnimation {
                                    combo[index] = replacementMove
                                }
                            }) {
                                Text("Random move")
                                Image(systemName: "shuffle")
                            }
                        }
//                        Button {
//                            chosenMove = move
//                        } label: {
//                            Text("View Info")
//                            Image(systemName: "info.circle")
//                        }

                    }
                    
RectangleMoveSeparator(index: index, combo: $combo)
                    
                    //                               if isLast {
                    //                                   Spacer()
                    //                                       .frame(height: 20)
                    //                               } else {
                    //                               }
                    
                    //                           }
                    //                       }
                    //                       .padding(.top, -10)
                    //                       .padding(.bottom, 10)
                }
                .onTapGesture {
                    chosenMove = move
                }
//                .onTapGesture {
//                    chosenIndex = index
//                }
            }
            .onMove(perform: move)
            .onDelete(perform: deleteItem)
            .listRowSeparator(.hidden)
        }
        .padding(.bottom, 100)
        .listStyle(PlainListStyle())
        .toolbar {
//                        Button {
//                            HapticsManager.shared.mediumVibrate()
//                            verticalLayout.toggle()
//                        } label: {
//                            Image(systemName: verticalLayout ? "arrowtriangle.up" : "arrowtriangle.down.fill")
//                                .font(.body)
//                        }
            Button {
                HapticsManager.shared.mediumVibrate()
                isColorCoded.toggle()
                // Save the new selection index to UserDefaults
                UserDefaults.standard.set(isColorCoded, forKey: "isColorCodingOn")
            } label: {
                Image(systemName: isColorCoded ? "paintpalette" : "paintpalette.fill")
                    .font(.body)
            }
            EditButton()

            //                    Button {
            //                        combo = []
            //                    } label: {
            //                        Text("Clear")
            //                            .foregroundColor(.blue)
            //                    }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        combo.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteItem(at offsets: IndexSet) {
        combo.remove(atOffsets: offsets)
    }
}

struct ComboScrollView: View  {
    
//    @Binding var combo: [MockMove]
    @Binding var combo: [Move]
    @Binding var isAbsoluteRandomGen: Bool
    @State var index: IdentifiableInt?
    @State var verticalLayout = true
    @State var isColorCoded: Bool = true
//    @State var chosenMove: MockMove?
    @State var chosenMove: Move?
    @State var chosenMoveIndexForVideo: Int = 0
    
    @State var horizontalScrollViewRefreshID = UUID()
    
    var comboNamesString: String {
        var stringArray = combo.map {$0.name.lowercased()}
        stringArray[0] = stringArray[0].capitalizeFirstLetter()
        return stringArray.joined(separator: " to ") + "."
    }
    //
    //    @Binding var selectedLineup: [CategoryWithTempID]
    //    @Binding var refreshID: UUID
    //    var category: CategoryWithTempID
    
    var body: some View {
        ZStack {
            VStack {
                GeneratedComboHeaderView(verticalLayout: $verticalLayout, horizontalScrollViewRefreshID: $horizontalScrollViewRefreshID)
                if verticalLayout {
                    GeneratedComboList(combo: $combo, isColorCoded: $isColorCoded, isAbsoluteRandomGen: $isAbsoluteRandomGen, index: $index, chosenMove: $chosenMove, chosenIndex: $chosenMoveIndexForVideo)
                } else {
                    VStack {
                        Text(comboNamesString)
                            .font(.title)
                            .fontWeight(.light)
                        Spacer()
                    }
                    .padding(20)
                }
            }
            VStack {
                Spacer()
                
                ScrollView(.horizontal) {
                    HStack(spacing: 40) {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                //Shuffle moves in combo
                                combo.shuffle()
                            }
                            HapticsManager.shared.vibrate(for: .success)
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    Circle()
                                        .foregroundColor(.indigo.opacity(0.9))
                                    //                                InfiniteLoopGradientCircleView()
                                )
                                .opacity(0.9)
                        }
                        Button {
                            HapticsManager.shared.vibrate(for: .success)
                            withAnimation {
                                //Regenerate
                                if isAbsoluteRandomGen {
                                    combo =
//                                    DataManager.shared.mockGeneratedRandomMoves(comboLength: combo.count)
                                    DataManager.shared.generateRandomCombo(length: combo.count)
                                } else {
                                    regenerateWithSameCategoryOrder()
                                }
                            }
                            
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    Circle()
                                        .foregroundColor(.blue.opacity(0.9))
                                    //                                InfiniteLoopGradientCircleView()
                                )
                                .opacity(0.9)
                        }
                        Button {
                            HapticsManager.shared.vibrate(for: .success)
//                            combo.append(DataManager.shared.mockMoves.randomElement()!)
                            combo.append(DataManager.shared.allEnabledMoves.randomElement()!)
                        } label: {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    Circle()
                                        .foregroundColor(.green.opacity(0.9))
                                    //                                InfiniteLoopGradientCircleView()
                                )
                                .opacity(0.9)
                                .contextMenu {
                                    
                                    //                                    Button {
                                    //                                        combo.append( MockCat(applicableMoves: [MockMove(name: "Double gainer"), MockMove(name: "Swing cast")]).randomApplicableMove())
                                    //                                    } label: {
                                    //                                        HStack {
                                    //                                            Text("Add Specific Category")
                                    //                                            Image(systemName: "plus.circle")
                                    //                                        }
                                    //                                    }
//                                    let cats = DataManager.shared.mockCategories.prefix(5)
                                    let cats = DataManager.shared.categories.prefix(5)
                                    
                                    ForEach(cats) { cat in
                                        Button(cat.name) {
                                            combo.append(cat.randomApplicableMove())
                                        }
                                    }
     
                                    Button {
                                        //go to modal screen with scrollable table view selection
                                        index = IdentifiableInt(id:-1)
                                    } label: {
                                        Text("More...")
                                        Image(systemName: "arrow.up")
                                    }
                                    
                                    
                                    
                                }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                                .frame(width: 100)
                            Button {
                                HapticsManager.shared.vibrate(for: .success)
                                combo = []
                                horizontalScrollViewRefreshID = UUID()
                            } label: {
                                Image(systemName: "trash")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(
                                        Circle()
                                            .foregroundColor(.red.opacity(0.9))
                                        //                                InfiniteLoopGradientCircleView()
                                    )
                                    .opacity(0.9)
                            }
                            
                            Spacer()
                                .frame(width: 175)
                        }
                        //                    .padding(.trailing, 25)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(combo.isEmpty || !verticalLayout)
                .id(self.horizontalScrollViewRefreshID)
            
            }
        }
        .sheet(item: $index) { i in
            SelectCategoryScreen(combo: $combo, index: i.id)
        }
        .sheet(item: $chosenMove) { move in
            ViewMoveDetailsScreen(move: move)
        }
        .onChange(of: chosenMoveIndexForVideo, perform: { index in
            let move = combo[index]
            DataManager.shared.openYoutubeLink(from: move)
        })
        .onAppear {
            // Load the last saved selection index
            let colorCodingPreference = UserDefaults.standard.bool(forKey: "isColorCodingOn")
                self.isColorCoded = colorCodingPreference
            
        }
        
    }
    

    
    func regenerateWithSameCategoryOrder() {
//        let categoryLineup = combo.map {$0.category}
//        var categoryLineup = [MockCat]()
        var categoryLineup = [Category]()
        for move in combo {
//            let category = DataManager.shared.mockCategories.first(where: {$0.applicableMoves.contains(where: {$0==move})})!
            categoryLineup.append(move.category)
        }
        var catLineupFormatted: [CategoryWithTempID] = []
        for cat in categoryLineup {
            catLineupFormatted.append(CategoryWithTempID(category: cat))
        }
//        let newCombo = DataManager.shared.mockGeneratedandomMovesInSpecificLine(categoryOrder: catLineupFormatted)
        let newCombo = DataManager.shared.generateRandomMovesInSpecificLine(categoryOrder: catLineupFormatted)
        combo = newCombo
    }
}

struct InfiniteLoopGradientCircleView: View {
    @State private var gradientPosition: CGFloat = 0.0

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(uiColor: #colorLiteral(red: 0.05605738156, green: 0.8930194739, blue: 0.4960271083, alpha: 1)), Color.teal]),
                    startPoint: UnitPoint(x: gradientPosition, y: 0.25),
                    endPoint: UnitPoint(x: gradientPosition - 1, y: 0.25)
                )
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 7.0).repeatForever(autoreverses: true)) {
                    gradientPosition = 2.5
                }
            }
    }
}


//struct GeneratedCombosScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            GeneratedCombosScreen(combo: [MockMove(name: "dive roll", category: MockCat(name: "rolls", applicableMoves: [MockMove(name: "front roll"), MockMove(name: "side roll"), MockMove(name: "pop back roll")])), MockMove(name: "webster"), MockMove(name: "butt spin"), MockMove(name: "machine"), MockMove(name: "baby freeze")])
//        }
//    }
//}

//struct DoubleSidedButton: View {
//    var body: some View {
//        HStack(spacing: 0) {
//            Spacer()
//            CustomRoundedRectangle(cornerRadius: 20)
//                .fill(Color.blue)
//                .frame(width: 120, height: 60)
//            CustomRoundedRectangle(cornerRadius: 20)
//                .fill(Color.indigo)
//                .frame(width: 120, height: 60)
//                .scaleEffect(x: -1, y: 1) // Reflect over the y-axis
//            Spacer()
//        }
//    }
//}

//struct CustomRoundedRectangle: Shape, InsettableShape {
//    var cornerRadius: CGFloat = 20
//    var insetAmount: CGFloat = 0
//    
//    func path(in rect: CGRect) -> Path {
//        var path = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).path(in: rect)
//        
//        // Adding the straight line on the right side
//        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX + insetAmount, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.minX + cornerRadius + insetAmount, y: rect.maxY))
//        
//        // Top-left corner
//        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
//        
//        // Top-right corner
//        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY + insetAmount))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + insetAmount))
//        
//        // Bottom-right corner
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
//        
//        // Bottom-left corner
//        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
//                    radius: cornerRadius,
//                    startAngle: Angle(degrees: 0),
//                    endAngle: Angle(degrees: 90),
//                    clockwise: false)
//        
//        // Complete the path
//        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
//        return path
//    }
//    
//    func inset(by amount: CGFloat) -> CustomRoundedRectangle {
//        var roundedRect = self
//        roundedRect.insetAmount += amount
//        return roundedRect
//    }
//}
