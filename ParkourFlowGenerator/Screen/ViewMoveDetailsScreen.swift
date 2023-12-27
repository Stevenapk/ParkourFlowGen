//
//  ViewMoveDetailsScreen.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/19/23.
//

import SwiftUI

struct ViewMoveDetailsScreen: View {
    
    //    var move: MockMove
    var move: Move
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Text(move.name.capitalized)
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
            }
            .background(Rectangle().foregroundColor(.red).opacity(0.4))
            .padding(.bottom)
            VStack(alignment: .leading, spacing: 10) {
                Text("Description:")
                    .font(.title3)
                    .bold()
                Text(move.descriptionOrPlaceholder)
                    .padding(.bottom, 20)
                //            if !move.linkString.isEmpty {
                //                Button {
                //                    if let url = URL(string: move.linkString) {
                //                        UIApplication.shared.open(url)
                //                    }
                //                } label: {
                //                    VStack {
                //                        HStack {
                //                            Spacer()
                //                            Text("Video")
                //                                .font(.title3)
                //                                .bold()
                //                            Image(systemName: "link")
                //                            Spacer()
                //                        }
                //                        .foregroundColor(.primary)
                //                        HStack {
                //                            Spacer()
                //                            Image(systemName: "play.fill")
                //                                .foregroundColor(.white)
                //                                .font(.title3)
                //                                .bold()
                //                                .padding(5)
                //                                .padding(.horizontal, 15)
                //                                .background(
                //                                    Capsule()
                //                                        .foregroundColor(.red)
                //                                )
                //                            Spacer()
                //                        }
                //                    }
                //                }
                //            }
                Button {
                    DataManager.shared.openYoutubeLink(from: move)
                } label: {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Video")
                                .font(.title3)
                                .bold()
                            Image(systemName: "link")
                            Spacer()
                        }
                        .foregroundColor(.primary)
                        HStack {
                            Spacer()
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                                .padding(5)
                                .padding(.horizontal, 15)
                                .background(
                                    Capsule()
                                        .foregroundColor(.red)
                                )
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .ignoresSafeArea()

        
    }
}

//struct ViewMoveDetailsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let dummyMove = Move(context: Constants.context)
//        dummyMove.name = "Back tuck"
//        dummyMove.linkString  = "https://youtube.com"
//        
//        ViewMoveDetailsScreen(move: dummyMove)
//        
////        ViewMoveDetailsScreen(move: MockMove(name: "Gainer full", linkString: "https://youtube.com"))
//        
//    }
//}
