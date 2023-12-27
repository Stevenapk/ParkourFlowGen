//
//  LoadingScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/22/23.
//

import SwiftUI

struct LoadingScreen: View {
    
    @Binding var shouldShowTabView: Bool
    
    @State var progressPercent: CGFloat = 0.0
    @State private var counter = 5
    @State private var timer: Timer?
    
    @State var selection = -1
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) var categories: FetchedResults<Category>
    
    var body: some View {
        VStack {
            
            // Logo
            Image(systemName: "triangle")
                .foregroundColor(.red)
                .font(.largeTitle)
                .padding()
            
            // App Name
            Text("Parkour Flow")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            if selection == -1 {
            
            Button {
                DataManager.shared.generateDefaults(defaultsDataManager: DefaultsDataManager()) {
                    
                }
                selection = 1
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    startCounting()
                }
            } label: {
                Text("New")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 80)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 20.0).foregroundColor(.blue))
            }
            
            Button {
                selection = 1
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    startCounting()
                }
            } label: {
                Text("Load")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 77)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 20.0).foregroundColor(.blue))
            }
                Spacer()
                    .frame(height: 100)
            
        }
            
            if selection != -1 {
            // Loading Bar
            ProgressBar(percent: $progressPercent)
                .padding(.top, -20)
            Text(counter != 0 ? "\(counter)s" : "")
                    .padding(.bottom, 153)
        }
        }
        .onChange(of: selection) { newSelection in
            // If NEW was selected
            if newSelection == 0 {
                
                // Delete any prior loaded categories
                for category in categories {
                    Constants.context.delete(category)
                }
                
                // Generate default categories
                DataManager.shared.generateDefaults(defaultsDataManager: DefaultsDataManager()) {}
                
            // If LOAD was selected
            } else {
                // Do nothing; wait for loading bar to finish and transition to screen with loaded data
            }
        }
    }
    
    private func startCounting() {
        
        // Start progress bar
        withAnimation(.easeIn(duration: 5.0)) {
            progressPercent = 1.0
        }
        
        // Invalidate any existing timer
        timer?.invalidate()
        
        // Use a timer to update the counter every 0.05 seconds (5 seconds / 100 steps)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            withAnimation {
                //Increment the counter
                self.counter -= 1
                
                //Stop the timer when we reach 100
                if counter == 0 {
                    timer?.invalidate()
                    DataManager.shared.setAppStatus()
                    shouldShowTabView = true
                }
            }
        }
    }
}

//struct LoadingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingScreen()
//    }
//}
