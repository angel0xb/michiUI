//
//  CapsuleHeader.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//

import SwiftUI

public struct CapsuleHeader: View {
    let title: AttributedString?
    let subtitle: AttributedString?
    let description: AttributedString?
 
    
    public init(
        title: AttributedString? = nil,
        subtitle: AttributedString? = nil,
        description: AttributedString? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let title {
                Text(title)
                    .font(.token(.titleSmall))
                    .lineLimit(1)
                
                if subtitle != nil || description != nil {
                    dottedDivider
                }
            }
            
            if let subtitle {
                Text(subtitle)
                    .font(.token(.labelSmall))
                    .lineLimit(1)
                
                if description != nil {
                    solidDivider
                }
            }
            
            if let description {
                Text(description)
                    .font(.tokenLight(.labelExtraSmall))
                    .lineLimit(3)
                    .foregroundStyle(Color.token(.blueAccent))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.token(.orangeYellowSurface))
        .clipShape(Capsule())
        .dottedBorder(
            cornerRadius: 100, // Large corner radius for capsule shape
            lineWidth: 3,
            dashLength: 8,
            gapLength: 4,
            color: .token(.black)
        )
    }
    
    private var dottedDivider: some View {
        Path { path in
            path.move(to: CGPoint(x: 1.5, y: 0))
            path.addLine(to: CGPoint(x: 1.5, y: 34))
        }
        .stroke(style: StrokeStyle(lineWidth: 3, dash: [7, 5]))
        .foregroundColor(.token(.black))
        .frame(width: 3, height: 34)
        .fixedSize(horizontal: true, vertical: true)
    }
    
    private var solidDivider: some View {
        Color.token(.black)
            .frame(width: 2, height: 34)
            .fixedSize(horizontal: true, vertical: true)
    }
}

#Preview {
    CapsuleHeader(title: "基 本 ア ク シ ョ ン ", subtitle: "BASIC ACTION", description: "ア イ テ ム な し で O K の キ ャ ラ ク タ ー 固 有 の ア ク シ ョ ン")
    
    
    CapsuleHeader(title: "Basic Actions", subtitle: "BASIC ACTION", description: "Character-specific actions that can be performed without any items.")
    
    
    CapsuleHeader(subtitle: "BASIC ACTION", description: "Character-specific actions that can be performed without any items.")
    
    
    CapsuleHeader(title: "Basic Actions", description: "Character-specific actions that can be performed without any items.")
    
}
