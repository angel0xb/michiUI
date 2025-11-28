//
//  StripedPattern.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//

import SwiftUI

/// Direction for stripe patterns
enum StripeDirection {
    case horizontal
    case vertical
    case diagonal
    case diagonalReversed
}

/// A view that creates a striped pattern with alternating gray lines
struct StripedPattern: View {
    var stripeWidth: CGFloat = 4
    var color1: Color = Color.gray.opacity(0.2)
    var color2: Color = Color.gray.opacity(0.4)
    var direction: StripeDirection = .diagonal
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let size = max(width, height)
            
            Canvas { context, canvasSize in
                switch direction {
                case .horizontal:
                    drawHorizontalStripes(context: context, width: width, height: height)
                case .vertical:
                    drawVerticalStripes(context: context, width: width, height: height)
                case .diagonal:
                    drawDiagonalStripes(context: context, size: size, reversed: false)
                case .diagonalReversed:
                    drawDiagonalStripes(context: context, size: size, reversed: true)
                }
            }
            .frame(width: width, height: height)
        }
    }
    
    private func drawHorizontalStripes(context: GraphicsContext, width: CGFloat, height: CGFloat) {
        let numberOfStripes = Int(height / stripeWidth) + 1
        for i in 0..<numberOfStripes {
            let offset = CGFloat(i) * stripeWidth
            let color = i % 2 == 0 ? color1 : color2
            
            var path = Path()
            path.move(to: CGPoint(x: 0, y: offset))
            path.addLine(to: CGPoint(x: width, y: offset))
            path.addLine(to: CGPoint(x: width, y: offset + stripeWidth))
            path.addLine(to: CGPoint(x: 0, y: offset + stripeWidth))
            path.closeSubpath()
            
            context.fill(path, with: .color(color))
        }
    }
    
    private func drawVerticalStripes(context: GraphicsContext, width: CGFloat, height: CGFloat) {
        let numberOfStripes = Int(width / stripeWidth) + 1
        for i in 0..<numberOfStripes {
            let offset = CGFloat(i) * stripeWidth
            let color = i % 2 == 0 ? color1 : color2
            
            var path = Path()
            path.move(to: CGPoint(x: offset, y: 0))
            path.addLine(to: CGPoint(x: offset + stripeWidth, y: 0))
            path.addLine(to: CGPoint(x: offset + stripeWidth, y: height))
            path.addLine(to: CGPoint(x: offset, y: height))
            path.closeSubpath()
            
            context.fill(path, with: .color(color))
        }
    }
    
    private func drawDiagonalStripes(context: GraphicsContext, size: CGFloat, reversed: Bool) {
        let diagonal = size * sqrt(2)
        let startOffset = -size
        let endOffset = size + diagonal
        let totalWidth = endOffset - startOffset
        let numberOfStripes = Int(totalWidth / stripeWidth) + 1
        
        for i in 0..<numberOfStripes {
            let offset = startOffset + CGFloat(i) * stripeWidth
            let color = i % 2 == 0 ? color1 : color2
            
            var path = Path()
            if reversed {
                // Top-right to bottom-left
                path.move(to: CGPoint(x: size, y: offset))
                path.addLine(to: CGPoint(x: 0, y: offset + size))
                path.addLine(to: CGPoint(x: 0, y: offset + size + stripeWidth))
                path.addLine(to: CGPoint(x: size, y: offset + stripeWidth))
            } else {
                // Top-left to bottom-right
                path.move(to: CGPoint(x: offset, y: 0))
                path.addLine(to: CGPoint(x: offset + size, y: size))
                path.addLine(to: CGPoint(x: offset + size + stripeWidth, y: size))
                path.addLine(to: CGPoint(x: offset + stripeWidth, y: 0))
            }
            path.closeSubpath()
            
            context.fill(path, with: .color(color))
        }
    }
}

/// A reusable view for displaying status items with icons and counts using badge style
struct StatusItemView: View {
    let iconName: String
    let count: Int
    var borderColor: Color = .secondary
    var stripeDirection: StripeDirection = .diagonal
    
    var body: some View {
        ZStack {
            StripedPattern(stripeWidth: 2, direction: stripeDirection)
                .clipShape(Circle())
            
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(7)
                .overlay(
                    MultiStrokeCircle(
                        outerColor: .black,
                        outerWidth: 1,
                        middleColor: .white,
                        middleWidth: 1,
                        innerColor: borderColor.opacity(0.9),
                        innerWidth: 3
                    )
                )
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(count)")
                                .font(.caption)
                                .padding(4)
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                .background(Color.white.clipShape(.circle))
                        }
                        .padding(.leading)
                        Spacer()
                    }
                }
        }
        .fixedSize()
        
    }
}

#Preview {
    StripedPattern(
        stripeWidth: 2,
        color1: .gray.opacity( 0.4),
        color2: .gray.opacity( 0.6),
        direction: .diagonal
    )
    .frame(width: 100, height: 100)
    
    StripedPattern(
        stripeWidth: 2,
        color1: .gray.opacity( 0.4),
        color2: .gray.opacity( 0.6),
        direction: .diagonalReversed
    )
    .frame(width: 100, height: 100)
    
    StripedPattern(
        stripeWidth: 1,
        color1: .gray.opacity( 0.4),
        color2: .gray.opacity( 0.6),
        direction: .horizontal
    )
    .frame(width: 100, height: 100)
    
    StripedPattern(
        stripeWidth: 1,
        color1: .gray.opacity( 0.4),
        color2: .gray.opacity( 0.6),
        direction: .vertical
    )
    .frame(width: 100, height: 100)
    
}
