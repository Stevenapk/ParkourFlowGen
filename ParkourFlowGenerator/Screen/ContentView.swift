//
//  ContentView.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var shouldShowTabView: Bool
    @State private var selection = 0

    init() {
        // Load the last saved selection index
        if let savedSelection = UserDefaults.standard.value(forKey: "lastSelectedIndex") as? Int {
            self._selection = State(initialValue: savedSelection)
        }
        
        shouldShowTabView = DataManager.shared.hasAppBeenOpenedBefore()
        
        // Generate defaults if necessary
        // TODO: finish this implementation
//        DataManager.shared.generateDefaultsIfNeeded {
//
//        }
        
    }

    var body: some View {
        
        NavigationView {
            
            if shouldShowTabView {
                TabView(selection: $selection) {
                    ChooseLineOrderScreen(selection: $selection)
                        .tabItem {
                            Image(systemName: "1.circle")
                            Text("Screen 1")
                        }
                        .tag(0)
                        .padding(.top, 60)
                    HomeScreen(selection: $selection)
                        .tabItem {
                            Image(systemName: "2.circle")
                            Text("Screen 2")
                        }
                        .tag(1)
                        .padding(.top, 60)
                }
                .ignoresSafeArea()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: selection) { newValue in
                    // Save the new selection index to UserDefaults
                    UserDefaults.standard.setValue(newValue, forKey: "lastSelectedIndex")
                }
            // App has not been opened before
            } else {
                LoadingScreen(shouldShowTabView: $shouldShowTabView)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
