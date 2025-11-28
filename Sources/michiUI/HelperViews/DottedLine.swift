//
//  DottedLine.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI

public struct DottedLine: Shape {
    var dotRadius: CGFloat = 1
    var spacing: CGFloat = 6
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerY = rect.midY
        var x: CGFloat = dotRadius
        
        while x < rect.width {
            path.addEllipse(in: CGRect(
                x: x - dotRadius,
                y: centerY - dotRadius,
                width: dotRadius * 2,
                height: dotRadius * 2
            ))
            x += dotRadius * 2 + spacing
        }
        
        return path
    }
}
