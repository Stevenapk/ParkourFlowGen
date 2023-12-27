//
//  ProgressBar.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/22/23.
//

import SwiftUI

struct ProgressBar: View {
    var width: CGFloat = 200
    var height: CGFloat = 20
    @Binding var percent: CGFloat
    var backgroundColor: Color = .black
    var color1 = Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    var color2 = Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
    
    var body: some View {
        let multiplier = width
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: width, height: height)
                .foregroundColor(backgroundColor.opacity(0.5))
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: percent*multiplier, height: height)
                .background(
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous))
                )
                .foregroundColor(.clear)
        }
    }
}

//struct ProgressBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBar(percent: 0.69)
//    }
//}
