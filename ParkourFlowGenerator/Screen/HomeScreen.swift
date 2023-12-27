//
//  HomeScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/16/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @Binding var selection: Int
    
    @State private var counter: Int = 1
    @State var shouldResetCounter = false
    
    var body: some View {
        VStack {
            Text("Random Combo")
                .font(.title)
                .bold()
                .padding(.top, 20)
            Spacer()
            VStack {
                Text("Number of Moves")
                    .font(.title2)
                    .padding(.vertical, -15)
                
                HStack {
                    Button(action: {
                        if self.counter > 1 {
                            self.counter -= 1
                            HapticsManager.shared.vibrate(for: .success)
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.largeTitle)
                            .foregroundColor(self.counter > 1 ? .red : Color(uiColor: .secondarySystemBackground))
                    }
                    
                    Text("\(counter)")
                        .font(.title)
                    
                    Button(action: {
                        if self.counter <= 24 {
                            self.counter += 1
                            HapticsManager.shared.vibrate(for: .success)
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                    })
                    {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                            .foregroundColor(self.counter < 25 ? .green : Color(uiColor: .secondarySystemBackground))
                    }
                    
                }
                .padding()
                
                NavigationLink {
                    let randomCombo = DataManager.shared.generateRandomCombo(length: counter)
                    GeneratedCombosScreen(combo: randomCombo, isAbsoluteRandomGen: true)
                } label: {
                    Text("Generate")
                        .font(.title2)
                        .padding(15)
                        .foregroundColor(.white)
                        .bold()
                        .background(
                            Capsule()
                                .foregroundColor(.blue)
                        )
                }
            }
            .offset(y: -15)
            Spacer()
            HStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.gray)
                        Text("Custom")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .offset(y: -15)
                }
                .onTapGesture {
                    selection = 0
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    VStack {
                        Image(systemName: "shuffle")
                            .foregroundColor(.green)
                        Text("Random")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .offset(y: -15)
                }
            }
            .background(Rectangle()
                .foregroundColor(Color(uiColor: #colorLiteral(red: 0.06891439419, green: 0.06891439419, blue: 0.06891439419, alpha: 0.8470588235))))
            .frame(height: 90)
        }
//        .background(Rectangle()
//            .foregroundColor(Color(uiColor: #colorLiteral(red: 0.06891439419, green: 0.06891439419, blue: 0.06891439419, alpha: 0.8470588235))))
        .ignoresSafeArea()
        .onAppear {
            if shouldResetCounter {
                resetCounter()
            }
        }
        .onDisappear {
            shouldResetCounter = true
        }
    }
    
    func resetCounter() {
        counter = 1
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(selection: .constant(0))
    }
}
