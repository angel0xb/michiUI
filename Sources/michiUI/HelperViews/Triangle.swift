//
//  Triangle.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI

/// Direction/orientation for triangle shapes
public enum TriangleDirection: Sendable {
    case up
    case down
    case left
    case right
}

/// Type of triangle shape
public enum TriangleType: Sendable {
    case equilateral  // All sides equal
    case isosceles    // Two sides equal
    case right        // Right-angled triangle
    case scalene      // All sides different
}

/// A customizable triangle shape with multiple variations
public struct Triangle: Shape {
    var direction: TriangleDirection
    var type: TriangleType
    
    public init(direction: TriangleDirection = .up, type: TriangleType = .equilateral) {
        self.direction = direction
        self.type = type
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        switch (direction, type) {
        // Equilateral triangles (all sides equal)
        case (.up, .equilateral):
            path.move(to: CGPoint(x: centerX, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
            
        case (.down, .equilateral):
            path.move(to: CGPoint(x: centerX, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.closeSubpath()
            
        case (.left, .equilateral):
            path.move(to: CGPoint(x: 0, y: centerY))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
            
        case (.right, .equilateral):
            path.move(to: CGPoint(x: width, y: centerY))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            
        // Isosceles triangles (two sides equal)
        case (.up, .isosceles):
            path.move(to: CGPoint(x: centerX, y: 0))
            path.addLine(to: CGPoint(x: width * 0.2, y: height))
            path.addLine(to: CGPoint(x: width * 0.8, y: height))
            path.closeSubpath()
            
        case (.down, .isosceles):
            path.move(to: CGPoint(x: centerX, y: height))
            path.addLine(to: CGPoint(x: width * 0.2, y: 0))
            path.addLine(to: CGPoint(x: width * 0.8, y: 0))
            path.closeSubpath()
            
        case (.left, .isosceles):
            path.move(to: CGPoint(x: 0, y: centerY))
            path.addLine(to: CGPoint(x: width, y: height * 0.2))
            path.addLine(to: CGPoint(x: width, y: height * 0.8))
            path.closeSubpath()
            
        case (.right, .isosceles):
            path.move(to: CGPoint(x: width, y: centerY))
            path.addLine(to: CGPoint(x: 0, y: height * 0.2))
            path.addLine(to: CGPoint(x: 0, y: height * 0.8))
            path.closeSubpath()
            
        // Right triangles (right-angled)
        case (.up, .right):
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            
        case (.down, .right):
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            
        case (.left, .right):
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            
        case (.right, .right):
            path.move(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
            
        // Scalene triangles (all sides different)
        case (.up, .scalene):
            path.move(to: CGPoint(x: width * 0.3, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.7))
            path.closeSubpath()
            
        case (.down, .scalene):
            path.move(to: CGPoint(x: width * 0.3, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.3))
            path.closeSubpath()
            
        case (.left, .scalene):
            path.move(to: CGPoint(x: 0, y: height * 0.3))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.9))
            path.closeSubpath()
            
        case (.right, .scalene):
            path.move(to: CGPoint(x: width, y: height * 0.3))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width * 0.3, y: height * 0.9))
            path.closeSubpath()
        }
        
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Equilateral Triangles")
            .font(.headline)
        
        HStack(spacing: 20) {
            Triangle(direction: .up, type: .equilateral)
                .fill(.blue)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .down, type: .equilateral)
                .fill(.red)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .left, type: .equilateral)
                .fill(.green)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .right, type: .equilateral)
                .fill(.orange)
                .frame(width: 60, height: 60)
        }
        
        Text("Isosceles Triangles")
            .font(.headline)
        
        HStack(spacing: 20) {
            Triangle(direction: .up, type: .isosceles)
                .fill(.purple)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .down, type: .isosceles)
                .fill(.pink)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .left, type: .isosceles)
                .fill(.cyan)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .right, type: .isosceles)
                .fill(.yellow)
                .frame(width: 60, height: 60)
        }
        
        Text("Right Triangles")
            .font(.headline)
        
        HStack(spacing: 20) {
            Triangle(direction: .up, type: .right)
                .fill(.mint)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .down, type: .right)
                .fill(.teal)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .left, type: .right)
                .fill(.indigo)
                .frame(width: 60, height: 60)
            
            Triangle(direction: .right, type: .right)
                .fill(.brown)
                .frame(width: 60, height: 60)
        }
        
        Text("Scalene Triangles")
            .font(.headline)
        
        HStack(spacing: 20) {
            Triangle(direction: .up, type: .scalene)
                .fill(.blue.opacity(0.7))
                .frame(width: 60, height: 60)
            
            Triangle(direction: .down, type: .scalene)
                .fill(.red.opacity(0.7))
                .frame(width: 60, height: 60)
            
            Triangle(direction: .left, type: .scalene)
                .fill(.green.opacity(0.7))
                .frame(width: 60, height: 60)
            
            Triangle(direction: .right, type: .scalene)
                .fill(.orange.opacity(0.7))
                .frame(width: 60, height: 60)
        }
        
        Text("With Stroke")
            .font(.headline)
        
        Triangle(direction: .up, type: .equilateral)
            .stroke(.black, lineWidth: 3)
            .frame(width: 80, height: 80)
        
        Triangle(direction: .down, type: .isosceles)
            .fill(.blue)
            .overlay(
                Triangle(direction: .down, type: .isosceles)
                    .stroke(.white, lineWidth: 2)
            )
            .frame(width: 80, height: 80)
    }
    .padding()
}

