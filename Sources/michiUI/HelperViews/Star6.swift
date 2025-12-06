//
//  Star6.swift
//  michiUI
//
//  Created by Angel Rodriguez on 12/28/25.
//

import SwiftUI

/// Color variant for the 6-pointed star
public enum Star6ColorVariant: Sendable {
    case customTeal
    case customBlue
    case orangeYellow
    case pink
    case purple
    case multicolored
    case dashedOutline
    case outline
}

/// A 6-pointed star shape
public struct Star6: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Create 6 points for the star (hexagram)
        // Each point is 60 degrees apart (360 / 6 = 60)
        let angleStep = CGFloat.pi / 3.0 // 60 degrees in radians
        
        // Outer points (the tips of the star)
        var outerPoints: [CGPoint] = []
        // Inner points (the indentations between tips)
        var innerPoints: [CGPoint] = []
        
        // Inner radius is typically about 0.5 of outer radius for a balanced star
        let innerRadius = radius * 0.5
        
        for i in 0..<6 {
            // Calculate angle (start at -90 degrees to have a point at top)
            let angle = CGFloat(i) * angleStep - CGFloat.pi / 2.0
            
            // Outer point
            let outerX = center.x + radius * cos(angle)
            let outerY = center.y + radius * sin(angle)
            outerPoints.append(CGPoint(x: outerX, y: outerY))
            
            // Inner point (offset by half step)
            let innerAngle = angle + angleStep / 2.0
            let innerX = center.x + innerRadius * cos(innerAngle)
            let innerY = center.y + innerRadius * sin(innerAngle)
            innerPoints.append(CGPoint(x: innerX, y: innerY))
        }
        
        // Draw the star by alternating between outer and inner points
        path.move(to: outerPoints[0])
        for i in 0..<6 {
            path.addLine(to: innerPoints[i])
            path.addLine(to: outerPoints[(i + 1) % 6])
        }
        path.closeSubpath()
        
        return path
    }
}

/// A shape that draws a single section of the 6-pointed star (one of 6 triangular sections)
public struct Star6Section: Shape {
    public let sectionIndex: Int
    public let totalSections: Int = 6
    
    public init(sectionIndex: Int) {
        self.sectionIndex = sectionIndex
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angleStep = CGFloat.pi / 3.0 // 60 degrees in radians
        let innerRadius = radius * 0.5
        
        // Calculate the angles for this section
        let startAngle = CGFloat(sectionIndex) * angleStep - CGFloat.pi / 2.0
        let endAngle = CGFloat((sectionIndex + 1) % totalSections) * angleStep - CGFloat.pi / 2.0
        let midAngle = startAngle + angleStep / 2.0
        
        // Get the three points for this triangular section
        let outerPoint1 = CGPoint(
            x: center.x + radius * cos(startAngle),
            y: center.y + radius * sin(startAngle)
        )
        let innerPoint = CGPoint(
            x: center.x + innerRadius * cos(midAngle),
            y: center.y + innerRadius * sin(midAngle)
        )
        let outerPoint2 = CGPoint(
            x: center.x + radius * cos(endAngle),
            y: center.y + radius * sin(endAngle)
        )
        
        // Draw the triangular section
        path.move(to: center)
        path.addLine(to: outerPoint1)
        path.addLine(to: innerPoint)
        path.addLine(to: outerPoint2)
        path.closeSubpath()
        
        return path
    }
}

/// A view that displays a 6-pointed star with a color variant
public struct Star6View: View {
    let variant: Star6ColorVariant
    
    public init(variant: Star6ColorVariant) {
        self.variant = variant
    }
    
    private var color: Color {
        switch variant {
        case .customTeal:
            return .token(.customTeal)
        case .customBlue:
            return .token(.customBlue)
        case .orangeYellow:
            return .token(.orangeYellowSurface)
        case .pink:
            return .token(.pinkAccent)
        case .purple:
            return .token(.customPurple)
        case .multicolored:
            return .clear // Not used for multicolored
        case .dashedOutline:
            return .white // Used for outline stroke
        case .outline:
            return .token(.black)
        }
    }
    
    private var colorForSection: [Color] {
        [
            .token(.customTeal),
            .token(.customBlue),
            .token(.orangeYellowSurface),
            .token(.pinkAccent),
            .token(.customPurple),
            .token(.customTeal) // Repeat first color for 6th section
        ]
    }
    
    public var body: some View {
        if variant == .multicolored {
            // Draw multicolored star with 6 sections
            ZStack {
                ForEach(0..<6, id: \.self) { index in
                    Star6Section(sectionIndex: index)
                        .fill(colorForSection[index])
                }
            }
            .clipShape(Star6())
        } else if variant == .dashedOutline {
            // Draw dashed outline
            Star6()
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        lineJoin: .round,
                        dash: [5, 5]
                    )
                )
        } else if variant == .outline {
            // Draw black outline
            Star6()
                .stroke(color, lineWidth: 2)
        } else {
            Star6()
                .fill(color)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        Text("6-Pointed Star Variants")
            .font(.token(.titleLarge))
            .padding(.bottom, 10)
        
        HStack(spacing: 40) {
            VStack(spacing: 10) {
                Star6View(variant: .customTeal)
                    .frame(width: 80, height: 80)
                Text("Custom Teal")
                    .font(.token(.labelSmall))
            }
            
            VStack(spacing: 10) {
                Star6View(variant: .customBlue)
                    .frame(width: 80, height: 80)
                Text("Custom Blue")
                    .font(.token(.labelSmall))
            }
            
            VStack(spacing: 10) {
                Star6View(variant: .orangeYellow)
                    .frame(width: 80, height: 80)
                Text("Orange Yellow")
                    .font(.token(.labelSmall))
            }
        }
        
        HStack(spacing: 40) {
            VStack(spacing: 10) {
                Star6View(variant: .pink)
                    .frame(width: 80, height: 80)
                Text("Pink")
                    .font(.token(.labelSmall))
            }
            
            VStack(spacing: 10) {
                Star6View(variant: .purple)
                    .frame(width: 40, height: 40)
                Text("Purple")
                    .font(.token(.labelSmall))
            }
            
            VStack(spacing: 10) {
                Star6View(variant: .multicolored)
                    .frame(width: 80, height: 80)
                Text("Multicolored")
                    .font(.token(.labelSmall))
            }
        }
        
        HStack(spacing: 40) {
            VStack(spacing: 10) {
                Star6View(variant: .dashedOutline)
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.3)) // Add background to see white outline
                Text("Dashed Outline")
                    .font(.token(.labelSmall))
            }
            
            VStack(spacing: 10) {
                Star6View(variant: .outline)
                    .frame(width: 80, height: 80)
                Text("Outline")
                    .font(.token(.labelSmall))
            }
        }
    }
    .padding()
}

