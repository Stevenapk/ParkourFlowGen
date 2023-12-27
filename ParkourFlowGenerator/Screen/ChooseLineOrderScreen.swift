//
//  ChooseLineOrderScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//

import SwiftUI

extension Array {
    func firstHalf() -> [Element] {
        
        let ct = self.count
        let half = (ct + 1) / 2
        let leftSplit = self[0 ..< half]
        return Array(leftSplit)
        
//        var result: [Element] = []
//
//        for (index, element) in enumerated() {
//            if index % 2 == 0 {
//                result.append(element)
//            }
//        }
//
//        return result
    }
    
    func secondHalf() -> [Element] {
        let ct = self.count
        let half = (ct + 1) / 2
        let rightSplit = self[half ..< ct]
        return Array(rightSplit)
        
//        var result: [Element] = []
//
//        for (index, element) in enumerated() {
//            if index % 2 != 0 {
//                result.append(element)
//            }
//        }
//
//        return result
    }
}

//struct CategoryWithTempID: Identifiable, Equatable, Hashable {
//    var category: MockCat
//    var id = UUID()
//
//    // Implement the hash(into:) method
//    func hash(into hasher: inout Hasher) {
//        // Combine hash values of all properties
//        hasher.combine(id)
//        hasher.combine(category)
//        // Combine hash values of other properties
//    }
//
//    // Implement the == operator for equality comparison
//    static func == (lhs: CategoryWithTempID, rhs: CategoryWithTempID) -> Bool {
//        // Compare all properties for equality
//        return lhs.id == rhs.id && lhs.category == rhs.category
//        // Add comparisons for other properties as needed
//    }
//}

struct CategoryWithTempID: Identifiable, Equatable, Hashable {
    var category: Category
    var id = UUID()
    
    // Implement the hash(into:) method
    func hash(into hasher: inout Hasher) {
        // Combine hash values of all properties
        hasher.combine(id)
        hasher.combine(category)
        // Combine hash values of other properties
    }
    
    // Implement the == operator for equality comparison
    static func == (lhs: CategoryWithTempID, rhs: CategoryWithTempID) -> Bool {
        // Compare all properties for equality
        return lhs.id == rhs.id && lhs.category == rhs.category
        // Add comparisons for other properties as needed
    }
}

struct MockCat: Identifiable, Equatable, Hashable {
    var id = UUID()
    var name = ["Flip", "Dismount Trick", "Parkour", "Bar Trick", "Flow Move"].randomElement()!
    var isEnabled = true
    var description = ""
    
    var descriptionOrPlaceholder: String {
        if description.isEmpty {
            return "No description available."
        } else {
            return description
        }
    }
    
    // Implement the hash(into:) method
    func hash(into hasher: inout Hasher) {
        // Combine hash values of all properties
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(isEnabled)
        // Combine hash values of other properties
    }
    
    // Implement the == operator for equality comparison
    static func == (lhs: MockCat, rhs: MockCat) -> Bool {
        // Compare id for equality
        return lhs.id == rhs.id
    }
    
//    var moves: NSSet = NSSet(array: [MockMove(name: "front roll"), MockMove(name: "side roll"), MockMove(name: "pop back roll")])
//
//    var applicableMoves: [MockMove] {
//        moves.allObjects as? [MockMove] ?? []
//    }
//
//    func randomApplicableMove() -> MockMove {
//        applicableMoves.randomElement()!
//    }
    
    var applicableMoves: [MockMove] = []
    
    func randomApplicableMove() -> MockMove {
       applicableMoves.randomElement()!
    }
    
    var color: Color {
        let uiColor: UIColor
        
        let firstLetter: Character = name.lowercased().first!
        
        if firstLetter.isLetter && name.count > 2 {
            
            let firstLetterValue: Int = Int(firstLetter.asciiValue!)
            
            let secondLetterValue: Int = Int(Character(String((name.lowercased().prefix(2).dropFirst()))).asciiValue!)

            let lastLetterValue: Int = Int(Character(String((name.lowercased().last!))).asciiValue!)

            let index = ((firstLetterValue + secondLetterValue + lastLetterValue)/3) * 3 - Int(Character("a").asciiValue!)
            let brightness: CGFloat = UITraitCollection.current.userInterfaceStyle == .dark ? 1.0 : 0.5
            uiColor = UIColor(hue: CGFloat(index) / 26.0, saturation: 0.8, brightness: brightness, alpha: 1.0)
            
        } else {
            return Color.gray
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

struct ChooseLineOrderHeaderView: View {
    
    @Binding var selectedLineup: [CategoryWithTempID]
    
    var body: some View {
        Text("Choose Custom Line")
            .font(.title)
            .bold()
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}

struct ChooseLineOrderScreen: View {
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) var categories: FetchedResults<Category>
    
    @State private var isColorCoded = false
    
    @Binding var selection: Int
    
    @State private var refreshID = UUID() // Unique identifier for view refreshing
    
    @State var selectedLineup: [CategoryWithTempID] = []
    
    var bottomMessageIndex: Int { selectedLineup.indices.last ?? 0 }
    
    // Function to scroll to bottom with animation
    func scrollToBottom(with proxy: ScrollViewProxy) {
        guard selectedLineup.indices.contains(bottomMessageIndex) else {
            return // Message index is out of bounds, do not scroll
        }
        withAnimation {
            proxy.scrollTo(bottomMessageIndex, anchor: .bottom)
        }
    }

//    var categories = DataManager.shared.categories
//    var categories = [MockCat(name: "Flow Move"), MockCat(name: "Dismount Trick"), MockCat(name: "Parkour Move"), MockCat(name: "Bar Trick"), MockCat(name: "Flip"), MockCat(name: "Tricking Move"), MockCat(name: "Flow Move"), MockCat(name: "Dismount Trick"), MockCat(name: "Parkour Move"), MockCat(name: "Bar Trick"), MockCat(name: "Flip"), MockCat(name: "Tricking Move")]
    
//    var categories = DataManager.shared.mockCategories
//    var categories = DataManager.shared.categories
//
    
    func deleteAllCategories() {
        for category in categories {
            Constants.context.delete(category)
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                ChooseLineOrderHeaderView(selectedLineup: $selectedLineup)
                HStack {
                    Spacer()
                    NavigationLink {
                        //                    CategoriesChecklistScreen()
                        let categoriesHubScreenVM = CategoriesChecklistViewModel(categories: Array(categories))
                        CategoriesHubScreen(vm: categoriesHubScreenVM)
                    } label: {
                        Image(systemName: "folder")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 30)
            }
            
            
            if !selectedLineup.isEmpty {
                HStack {
                    Text("Moves: \(selectedLineup.count)")
                        .font(.body)
                        .fontWeight(.light)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                HStack {
                    Spacer()
                    Button {
                        HapticsManager.shared.mediumVibrate()
                        isColorCoded.toggle()
                        // Save the new selection index to UserDefaults
                        UserDefaults.standard.set(isColorCoded, forKey: "isColorCodingHomeOn")
                    } label: {
                        Image(systemName: isColorCoded ? "paintpalette" : "paintpalette.fill")
                            .font(.body)
                    }
                    
                }
                .offset(y: -33)
                .padding(.horizontal, 34)
            }
            
            if !selectedLineup.isEmpty {
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(selectedLineup.indices, id: \.self) { index in
                                LineupCatsListForScrollview(selectedLineup: $selectedLineup, refreshID: $refreshID, isColorCoded: $isColorCoded, category: selectedLineup[index])
                            }
                            .padding(.top, -10)
                            .padding(.bottom, 10)
                            .onChange(of: selectedLineup) { _ in
                                // Scroll to the bottom whenever the items change
                                scrollToBottom(with: proxy)
                            }
                        }
                        .frame(height: 347)
                    }
                }
            } else {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(uiColor: .systemGroupedBackground))
                    Text("Your custom combo will go here.")
                        .font(.headline)
                }
                .frame(height: 465)
            }
            if !selectedLineup.isEmpty {
                ZStack {
                    GenerateButton(selectedLineup: selectedLineup)
                        .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("Clear")
                            .padding(.horizontal)
                            .onTapGesture {
                                HapticsManager.shared.selectionVibrate()
                                selectedLineup = []
                            }
                    }
                }
            }
            
            HStack(spacing: 0) {
                List(Array(categories).firstHalf()) { category in
                    CategoryMiniList(selectedLineup: $selectedLineup, refreshID: $refreshID, category: category)
                        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                            return 0
                        }
                }
                .listStyle(PlainListStyle())
                List(Array(categories).secondHalf()) { category in
                    CategoryMiniList(selectedLineup: $selectedLineup, refreshID: $refreshID, category: category)
                        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                            return 0
                        }
                }
                .listStyle(PlainListStyle())
            }
            
            HStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.green)
                        Text("Custom")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .offset(y: -15)
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    VStack {
                        Image(systemName: "shuffle")
                            .foregroundColor(.gray)
                        Text("Random")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .offset(y: -15)
                }
                .onTapGesture {
                    selection = 1
                }
            }
            .background(Rectangle()
                .foregroundColor(Color(uiColor: #colorLiteral(red: 0.06891439419, green: 0.06891439419, blue: 0.06891439419, alpha: 0.8470588235))))
            .frame(height: 90)
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            clear()
            // Load the color coding preference from user defaults
            let colorCodingPreference = UserDefaults.standard.bool(forKey: "isColorCodingHomeOn")
            self.isColorCoded = colorCodingPreference
            
            print(categories.map {$0.name})
            
        }
    }
    
    func clear() {
        selectedLineup = []
    }
}

struct LineupCatsListForScrollview: View  {
    
    @Binding var selectedLineup: [CategoryWithTempID]
    @Binding var refreshID: UUID
    @Binding var isColorCoded: Bool
    var category: CategoryWithTempID
    
    var index: Int {
        $selectedLineup.firstIndex(where: {$0.id == category.id})!
    }
    
    var isLast: Bool {
        if $selectedLineup.last?.id == category.id {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: -5) {
                VStack {
                    Text(category.category.name)
                        .bold()
                        .foregroundColor(isColorCoded ? category.category.color : .primary)
                        .padding(.vertical)
                        .padding(.horizontal, 70)
                }

            .contextMenu {
                Button(action: {
                    // Delete character action
                    selectedLineup.remove(at: index)
                }) {
                    Text("Remove")
                    Image(systemName: "trash.fill")
                }
            }

                HStack {
                    Spacer()
                    VStack {
                        Rectangle()
                            .frame(width: 5, height: 21)
                            .padding(.bottom, -15)
                    }
                    Spacer()
                }
            if isLast {
                Spacer()
                    .frame(height: 20)
            } else {
            }

        }
    }
}

struct GenerateButton: View {
    var selectedLineup: [CategoryWithTempID]
    var body: some View {
        NavigationLink {
            let combo = DataManager.shared.generateRandomMovesInSpecificLine(categoryOrder: selectedLineup)
            GeneratedCombosScreen(combo: combo)
        } label: {
            Text("Generate")
                .foregroundColor(.white)
                .font(.title3)
                .padding(10)
                .background(
                    Capsule()
                        .foregroundColor(.blue)
                )
                .padding(.top, 10)
        }
    }
}

struct CategoryMiniList: View {
    @Binding var selectedLineup: [CategoryWithTempID]
    @Binding var refreshID: UUID
    var category: Category
//    var category: MockCat
    
    var body: some View {
        HStack {
            Text(category.name)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Rectangle().foregroundColor(Color(uiColor: .systemBackground)))
        }
            .onTapGesture {
                HapticsManager.shared.selectionVibrate()
                selectedLineup.append(CategoryWithTempID(category: category))
            }
    }
}

struct ChooseLineOrderScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLineOrderScreen(selection: .constant(0))
    }
}



//struct StaticLineupCatsList: View {
//    @Binding var selectedLineup: [CategoryWithTempID]
//    var index: Int
//    var category: CategoryWithTempID
//    var body: some View {
//        VStack(alignment: .center, spacing: -5) {
//                VStack {
//                    Text(category.category.name)
//                        .bold()
//                        .padding(.vertical)
//                        .padding(.horizontal, 70)
//                }
//            .contextMenu {
//                Button(action: {
//    //                        viewModel.characterToEdit = character // Edit character action
//                }) {
//                    Text("Change")
//                    Image(systemName: "pencil")
//                }
//                Button(action: {
//                    selectedLineup.remove(at: index)
//                }) {
//                    Text("Remove")
//                    Image(systemName: "trash.fill")
//                }
//            }
//
//
//                HStack {
//                    Spacer()
//                    VStack {
//                        Rectangle()
//                            .frame(width: 5, height: 21)
//                            .padding(.bottom, -5)
//                    }
//                    Spacer()
//                }
//
//
//        }
//    }
//}
