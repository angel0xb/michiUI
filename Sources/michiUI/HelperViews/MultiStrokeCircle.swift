//
//  MultiStrokeCircle.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//

import SwiftUI

/// A view that creates multiple concentric circle strokes
struct MultiStrokeCircle: View {
    let outerColor: Color
    let outerWidth: CGFloat
    let middleColor: Color
    let middleWidth: CGFloat
    let innerColor: Color
    let innerWidth: CGFloat
    
    var body: some View {
        Circle()
            .stroke(outerColor, lineWidth: outerWidth)
            .padding(outerWidth / 2)
            .overlay {
                Circle()
                    .stroke(middleColor, lineWidth: middleWidth)
                    .padding(outerWidth + middleWidth / 2)
                    .overlay {
                        Circle()
                            .stroke(innerColor, lineWidth: innerWidth)
                            .padding(outerWidth + middleWidth + innerWidth / 2)
                    }
            }
    }
}

#Preview {
    MultiStrokeCircle(
        outerColor: .token(.customDarkBlue),
        outerWidth: 2,
        middleColor: .token( .orangeYellowSurface),
        middleWidth: 3,
        innerColor: .token(.pink),
        innerWidth: 5
    )
    .frame(width: 60, height: 60)
    
    MultiStrokeCircle(
        outerColor: .token(.customDarkBlue),
        outerWidth: 2,
        middleColor: .token(.customTeal),
        middleWidth: 3,
        innerColor: .token(.blueAccent),
        innerWidth: 5
    )
    .frame(width: 60, height: 60)
}
