//
//  DottedBorder.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//

import SwiftUI

/// A custom shape that draws a border with solid corners and dotted straight edges
struct DottedBorderShape: Shape {
    var cornerRadius: CGFloat
    var lineWidth: CGFloat
    var dashLength: CGFloat
    var gapLength: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let radius = min(cornerRadius, min(width, height) / 2)
        
        // Top-left corner (solid arc) - start here
        path.move(to: CGPoint(x: 0, y: radius))
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        // Top edge (dotted) - from top-left to top-right
        drawDottedLine(
            path: &path,
            from: CGPoint(x: radius, y: 0),
            to: CGPoint(x: width - radius, y: 0),
            dashLength: dashLength,
            gapLength: gapLength
        )
        
        // Top-right corner (solid arc) - ensure we're at the right position
        path.move(to: CGPoint(x: width - radius, y: 0))
        path.addArc(
            center: CGPoint(x: width - radius, y: radius),
            radius: radius,
            startAngle: .degrees(270),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        // Right edge (dotted) - from top-right to bottom-right
        drawDottedLine(
            path: &path,
            from: CGPoint(x: width, y: radius),
            to: CGPoint(x: width, y: height - radius),
            dashLength: dashLength,
            gapLength: gapLength
        )
        
        // Bottom-right corner (solid arc)
        path.move(to: CGPoint(x: width, y: height - radius))
        path.addArc(
            center: CGPoint(x: width - radius, y: height - radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        // Bottom edge (dotted) - from bottom-right to bottom-left
        drawDottedLine(
            path: &path,
            from: CGPoint(x: width - radius, y: height),
            to: CGPoint(x: radius, y: height),
            dashLength: dashLength,
            gapLength: gapLength
        )
        
        // Bottom-left corner (solid arc)
        path.move(to: CGPoint(x: radius, y: height))
        path.addArc(
            center: CGPoint(x: radius, y: height - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // Left edge (dotted) - from bottom-left to top-left
        drawDottedLine(
            path: &path,
            from: CGPoint(x: 0, y: height - radius),
            to: CGPoint(x: 0, y: radius),
            dashLength: dashLength,
            gapLength: gapLength
        )
        
        return path
    }
    
    private func drawDottedLine(
        path: inout Path,
        from start: CGPoint,
        to end: CGPoint,
        dashLength: CGFloat,
        gapLength: CGFloat
    ) {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let distance = sqrt(dx * dx + dy * dy)
        let angle = atan2(dy, dx)
        
        let totalSegmentLength = dashLength + gapLength
        var currentDistance: CGFloat = 0
        
        while currentDistance < distance {
            let segmentStart = currentDistance
            let segmentEnd = min(currentDistance + dashLength, distance)
            
            let startPoint = CGPoint(
                x: start.x + cos(angle) * segmentStart,
                y: start.y + sin(angle) * segmentStart
            )
            let endPoint = CGPoint(
                x: start.x + cos(angle) * segmentEnd,
                y: start.y + sin(angle) * segmentEnd
            )
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            currentDistance += totalSegmentLength
        }
    }
}

/// View modifier that applies a dotted border with solid corners
struct DottedBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 8
    var lineWidth: CGFloat = 2
    var dashLength: CGFloat = 4
    var gapLength: CGFloat = 4
    var color: Color = .primary
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                DottedBorderShape(
                    cornerRadius: cornerRadius,
                    lineWidth: lineWidth,
                    dashLength: dashLength,
                    gapLength: gapLength
                )
                .stroke(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    /// Applies a dotted border with solid corners around the view
    /// - Parameters:
    ///   - cornerRadius: The radius of the corners (default: 8)
    ///   - lineWidth: The width of the border line (default: 2)
    ///   - dashLength: The length of each dash (default: 4)
    ///   - gapLength: The length of each gap between dashes (default: 4)
    ///   - color: The color of the border (default: .primary)
    func dottedBorder(
        cornerRadius: CGFloat = 8,
        lineWidth: CGFloat = 2,
        dashLength: CGFloat = 4,
        gapLength: CGFloat = 4,
        color: Color = .primary
    ) -> some View {
        modifier(
            DottedBorderModifier(
                cornerRadius: cornerRadius,
                lineWidth: lineWidth,
                dashLength: dashLength,
                gapLength: gapLength,
                color: color
            )
        )
    }
}
