//
//  AddEditMoveScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/19/23.
//

import SwiftUI

struct AddEditMoveScreen: View {
    @Environment(\.dismiss) var dismiss
//    @State var moveToEdit: MockMove?
    @State var moveToEdit: Move?
    @State var showingDescription = false
    @State var showingLink = false
    @State var name = ""
    @State var description = ""
    @State var link = ""
//    @Binding var category: MockCat
    @Binding var category: Category
    @FocusState private var isNameTextFieldFocused: Bool
    @FocusState private var isDescriptionTextFieldFocused: Bool
    @FocusState private var isLinkTextFieldFocused: Bool
    
    var namePlaceholder: String = "Name"
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("CustomBackground"))
                    .padding(.bottom, -50)
                VStack(alignment: .leading) {
                    TextField(namePlaceholder, text: $name)
                        .focused($isNameTextFieldFocused)
                        .font(.title2)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding(7.5)
                    //                .background(
                    //                    RoundedRectangle(cornerRadius: 8)
                    //                        .fill(Color.clear)
                    //                )
                    //                .overlay(RoundedRectangle(cornerRadius: 8)
                    //                    .stroke(Color.secondary, lineWidth: 1)
                    //                )
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, 5)
                    HStack {
                        Text("Description (optional):")
                        Image(systemName: showingDescription ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    }
                    .foregroundColor(Color.primary)
                    .padding(.horizontal)
                    //            .padding(.horizontal, 7.5)
                    .onTapGesture {
                        HapticsManager.shared.vibrate(for: .success)
                        withAnimation(.easeInOut) {
                            showingDescription.toggle()
                        }
                    }
                    if showingDescription {
                        TextField("A single kick out of a backflip.", text: $description)
                            .padding(7.5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.clear)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            .focused($isDescriptionTextFieldFocused)
                            .onAppear {
                                DispatchQueue.main.async {
                                    isDescriptionTextFieldFocused = true
                                }
                            }
                    }
                    
                    HStack {
                        Text(link.isEmpty ? "Add Link (Optional)" : "Edit Link")
                        Image(systemName: "link")
                        Image(systemName: showingLink ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    }
                    .foregroundColor(Color.primary)
                    .padding(.horizontal)
                    //            .padding(.horizontal, 7.5)
                    .padding(.top, 20)
                    .onTapGesture {
                        HapticsManager.shared.vibrate(for: .success)
                        withAnimation(.easeInOut) {
                            showingLink.toggle()
                        }
                    }
                    if showingLink {
                        TextField("https://youtube.com", text: $link)
                            .padding(7.5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.clear)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            .focused($isLinkTextFieldFocused)
                            .onAppear {
                                DispatchQueue.main.async {
                                    isLinkTextFieldFocused = true
                                }
                            }
                    }
                    
                    if isValidURL() {
                        Button {
                            if let url = URL(string: link) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Test Link")
                                    .padding(7.5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.clear)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary, lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                    .padding(.bottom, 5)
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                }
                //Cancel Toolbar Item
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            HapticsManager.shared.mediumVibrate()
                            // Dismiss Screen
                            dismiss()
                        }) {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Save character to core data
                            //                    viewModel.saveCharacter(existingCharacter: character, completion: { needsRefresh in
                            //                        // If the homescreen needs to be refreshed because of specific changed data,
                            //                        if needsRefresh {
                            //                            // Trigger a refresh
                            //                            refreshID = UUID()
                            //                        }
                            //                    })
                            HapticsManager.shared.vibrate(for: .success)
                            
                            // Save changes
                            if moveToEdit != nil {
                                moveToEdit?.name = name
                                moveToEdit?.about = description
                                moveToEdit?.linkString = link
                                PersistenceController.shared.saveContext()
                            // Save new
                            } else {
                                let newMove = Move(context: Constants.context)
                                
                                newMove.name = name
                                newMove.about = description
                                newMove.linkString = link
                                newMove.category = category
                                PersistenceController.shared.saveContext()
                                
//                                let newMove = MockMove(name: name, description: description, linkString: link, category: category)
//                                category.applicableMoves.append(newMove)
                            }
                            
                            // Dismiss screen
                            dismiss()
                        }) {
                            Text("Save")
                        }
                        // Disable the save button if save conditions are not met
                        .disabled(!isValidForSave())
                    }
                }
                // Switch navigation title depending on if the user is creating a new contact or editing a previous one
                .navigationBarTitle(moveToEdit != nil ? "Edit Move" : "Add Move", displayMode: .inline)
                .padding()
                .onAppear {
                    if let moveToEdit {
                        
                        name = moveToEdit.name
                        description = moveToEdit.about
                        link = moveToEdit.linkString
                        
                        if !description.isEmpty {
                            showingDescription = true
                        }
                        
                        if !link.isEmpty {
                            showingLink = true
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    isNameTextFieldFocused = true
                }
            }
        }
    }
    func isValidURL() -> Bool {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
    
    func isValidForSave() -> Bool {
        
        //if name is not empty and not duplicate
        if !name.isEmpty && !usedNames.contains(name) {
            
            //if url is valid or empty
            if isValidURL() || link.isEmpty {
                
                //if editing previous move and any info has changed
                if let moveToEdit {
                    
                    return moveToEdit.name != name || moveToEdit.description != description || moveToEdit.linkString != link
                    
                } else {
                    
                // If adding new move
                    return true
                }
            }
        }
        return false
    }
    
    var usedNames: [String] = DataManager.shared.allMoveNames
    
//    var usedNames = ["backflip, cork"]
}

//struct AddEditMoveScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create an array of MockMove instances for preview
//        var cat = DataManager.shared.mockCategories[0]
//
//        // Create a binding to the array of MockMove instances
//        let binding = Binding<MockCat>(
//            get: { cat },
//            set: { newValue in cat = newValue }
//        )
//            AddEditMoveScreen(category: binding)
//
//    }
//}
