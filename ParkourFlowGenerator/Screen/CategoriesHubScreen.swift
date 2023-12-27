//
//  CategoriesHubScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/19/23.
//

import SwiftUI

//struct TextFieldCustomAlert: View {
//
//    @Environment(\.dismiss) var dismiss
//
//    var title: String = ""
//    var placeholder = ""
//    @State var text = ""
//    @State var isValidForSave = false
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 20.0)
//            VStack {
//                Text(title)
//                TextField(placeholder, text: $text)
//                HStack {
//                    Button {
//
//                    } label: {
//                        Text("Cancel")
//                    }
//                    Button {
//                        <#code#>
//                    } label: {
//                        Text("Save")
//                    }
//                }
//            }
//        }
//    }
//
//    var isValid: () -> Bool
//}

class CategoriesChecklistViewModel: ObservableObject {
    //    init(categories: [MockCat]) {
    //        self.categories = categories
    //    }
    //    @Published var categories: [MockCat]
    init(categories: [Category]) {
        self.categories = categories
    }
    @Published var categories: [Category]
}

struct CategoriesHubScreen: View {
    
    @ObservedObject var vm: CategoriesChecklistViewModel
    
    //    @FetchRequest(
    //        entity: Category.entity(),
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    //    ) var categories: FetchedResults<Category>
    
    @State var isShowingAddCategoryAlert = false
    @State var isShowingEditCategoryAlert = false
    @State var isShowingCategoriesSettingsScreen = false
    //    @State var categoryToEdit: MockCat?
    @State var categoryToEdit: Category?
    
    @State var name = ""
    @State var description = ""
    
    @FocusState var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(Array(zip(vm.categories.indices, vm.categories)), id: \.0) { index, category in
                        HStack {
                            Image(systemName: category.isEnabled ? "checkmark.square.fill" : "square")
                                .foregroundColor(category.isEnabled ? .primary : .gray)
                                .font(Font.title)
                                .onTapGesture {
                                    HapticsManager.shared.selectionVibrate()
                                    vm.categories[index].isEnabled.toggle()
                                    PersistenceController.shared.saveContext()
                                }
                            HStack {
                                Text(category.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                    .foregroundColor(category.isEnabled ? .primary : .gray)
                                    .onLongPressGesture (minimumDuration: 0.5) {
                                        HapticsManager.shared.mediumVibrate()
                                        updateCategoryToEdit(category) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                isShowingEditCategoryAlert.toggle()
                                            }
                                        }
                                    }
                                Spacer()
                                NavigationLink {
                                    let movesVM = MovesChecklistViewModel(category: category)
                                    MovesChecklistScreen(vm: movesVM)
                                } label: {
                                    Rectangle()
                                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                                        .opacity(0.1)
                                }
                            }
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: deleteCategory)
                }
                .toolbar {
//                    EditButton()
                    Button {
                        HapticsManager.shared.mediumVibrate()
                        //present alert with name and description
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isShowingAddCategoryAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    Button {
                        HapticsManager.shared.mediumVibrate()
                        isShowingCategoriesSettingsScreen.toggle()
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
        }
        .overlay(
            CustomTextFieldAlert(title: "Add Category", placeholder: "Enter name", isShowing: $isShowingAddCategoryAlert, text: $name, isFocused: _isNameFieldFocused, saveAction: addCategory, isInvalidForSave: isInvalidForSave)
        )
        .overlay(
            CustomTextFieldAlert(title: "Rename Category", placeholder: categoryToEdit?.name ?? "Error", isShowing: $isShowingEditCategoryAlert, text: $name, isFocused: _isNameFieldFocused, saveAction: editCategory, isInvalidForSave: isInvalidForSave)
        )
        .sheet(isPresented: $isShowingCategoriesSettingsScreen) {
            CategoriesSettingsScreen(categories: $vm.categories)
        }
        .navigationTitle("All Categories")
        .onAppear {
            print(vm.categories.map {$0.name})
        }
        .onDisappear {
            PersistenceController.shared.saveContext()
        }
    }
    
    func isInvalidForSave() -> Bool {
        return name.isEmpty || usedCategoryNames.contains(name)
    }
    
    func isNameDuplicate() -> Bool {
        return usedCategoryNames.contains(name)
    }
    
    var usedCategoryNames: [String] { vm.categories.map {$0.name} }
    
    //    func updateCategoryToEdit(_ category: MockCat, completion: @escaping () -> Void) {
    //        categoryToEdit = category
    //        completion()
    //    }
    func updateCategoryToEdit(_ category: Category, completion: @escaping () -> Void) {
        categoryToEdit = category
        completion()
    }
    
    //    func addCategory() {
    //        vm.categories.append(MockCat(name: name, description: description))
    //    }
    
    func addCategory() {
        let newCategory = Category(context: Constants.context)
        newCategory.name = name
        
        //        vm.categories.append(newCategory)
        
        PersistenceController.shared.saveContext()
    }
    
    func editCategory() {
        let index = vm.categories.firstIndex(where: {$0==categoryToEdit})!
        vm.categories[index].name = name
    }
    
    func move(from source: IndexSet, to destination: Int) {
        //        vm.categories.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteCategory(at offsets: IndexSet) {
        //        vm.categories.remove(atOffsets: offsets)
        //        for index in offsets {
        //            print(index)
        //            Constants.context.delete(categories[index])
        //        }
        if let index = offsets.first {
            
            let categoryToDelete = vm.categories[index]
            
            // Delay delete to ensure smooth prior animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Constants.context.delete(categoryToDelete)
            }
        }
        
    }
}

//struct CategoriesHubScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            //            CategoriesHubScreen(vm: CategoriesChecklistViewModel(categories: DataManager.shared.mockCategories))
//            //        }
//            CategoriesHubScreen(vm: CategoriesChecklistViewModel(categories: DataManager.shared.categories))
//        }
//    }
//}


struct CustomTextFieldAlert: View {
    
    var title: String
    var placeholder: String
    
    @Binding var isShowing: Bool
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var saveAction: () -> Void
    var isInvalidForSave: () -> Bool
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.3)
                    .onAppear {
                        isFocused = true
                    }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                VStack(spacing: 0) {
                    Text(title)
                        .bold()
                        .padding(.vertical)
                    TextField(placeholder, text: $text)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        .focused($isFocused)
                    Divider()
                    ZStack {
                        HStack(spacing: 0) {
                            Button {
                                isShowing = false
                                isFocused = false
                                text = ""
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            Rectangle()
                                .foregroundColor(Color(uiColor: .tertiarySystemBackground))
                                .frame(width: 1.0)
                            Button {
                                withAnimation {
                                    //Save new category
                                    saveAction()
                                }
                                isShowing = false
                                isFocused = false
                                text = ""
                            } label: {
                                Text("Save")
                                    .foregroundColor(isInvalidForSave() ? .gray : .green)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .disabled(isInvalidForSave())
                        }
                    }
                }
            }
            .frame(width: 250, height: 150)
            .offset(y: -150)
            .offset(y: isShowing ? 0 : UIScreen.main.bounds.height)
        }
        .ignoresSafeArea()
        .onAppear {
            if placeholder == "Error" {
                isShowing = false
            }
        }
        
    }
}
