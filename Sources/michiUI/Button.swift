//
//  Button.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI

public struct MichiButton: View {
    
    public enum Theme {
        case primary
        case secondary
        case pink
        case blueSecondary
        case purple
        case yellowOrange
    }
    
    public enum Style {
        case filled
        case plain
        case bordered
    }
    
    let title: String
    let theme: Theme
    let style: Style
    let action: () -> Void
    
    public init(
        _ title: String,
        theme: Theme = .primary,
        style: Style = .filled,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.theme = theme
        self.style = style
        self.action = action
    }
    
    // Helper to get theme color
    private var themeColor: ColorToken {
        switch theme {
        case .primary: .customTeal
        case .secondary: .tealSecondary
        case .pink: .pinkAccent
        case .blueSecondary: .blueSecondary
        case .purple: .purpleAccent
        case .yellowOrange: .yellowOrangeSecondary
        }
    }
    
    public var body: some View {
        Button(action: action) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var buttonContent: some View {
        let baseContent = Text(title)
            .font(.token(.titleSmall))
            .foregroundStyle(textColor)
       
        
        if style != .plain {
            baseContent
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .padding(2)
                .dottedBorder(
                    cornerRadius: 21,
                    lineWidth: 5,
                    dashLength: 16,
                    gapLength: 0,
                    color: .token(.tealSecondary)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(2)
                .overlay(alignment: .topTrailing) {
        //                    circle(alignment: .bottomLeading)
                }
                .overlay(alignment: .topLeading) {
        //                    circle(alignment: .bottomTrailing)
                }
                .overlay(alignment: .bottomLeading) {
        //                    circle(alignment: .topTrailing)
                }
                .overlay(alignment: /*.trailing*/ .bottomTrailing) {
                    HStack(alignment: .top, spacing: 1) {
                        Triangle(direction: .right)
                            .fill(Color.token(.pinkAccent))
                            .stroke(Color.token(.black), lineWidth: 2)
                            .frame(width: 15, height: 10)
                        
                        Triangle(direction: .right)
                            .fill(Color.token(.pinkAccent))
                            .stroke(Color.token(.black), lineWidth: 2)
                            .frame(width: 15, height: 10)
                            
                    }
                }
        } else {
            baseContent
                .padding(.top, 3)
                .padding(.trailing, 25)
                .background(alignment: .bottom) {
                    HStack(alignment: .top, spacing: 1) {
                        Spacer()
                        Triangle(direction: .right)
                            .fill(Color.token(.pinkAccent))
                            .stroke(Color.token(.black), lineWidth: 2)
                            .frame(width: 15, height: 10)
                        
                        Triangle(direction: .right)
                            .fill(Color.token(.pinkAccent))
                            .stroke(Color.token(.black), lineWidth: 2)
                            .frame(width: 15, height: 10)
                    }
                    .padding(.top)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
  
    }
    
    func circle(alignment: Alignment) -> some View {
        let trailings = [Alignment.trailing, .bottomTrailing, .topTrailing]
        return  Color.token(.tealContainer).clipShape(.circle)
            .frame( width: 12, height: 8)
            .dottedBorder(cornerRadius: 100, lineWidth: 4, color: .token(.black))
            .padding(trailings.contains(alignment) ? .leading  : .trailing, 4)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .filled: Color.token(themeColor)
        case .plain, .bordered: Color.clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .filled:
            return theme == .yellowOrange ? .token(.black) : .white
        case .plain, .bordered:
            return Color.token(themeColor)
        }
    }
}

#Preview {
    CustomFont.register()
    return ScrollView {
        VStack(spacing: 20) {
            // Filled style
            MichiButton("Primary Filled", theme: .primary, style: .filled) {}
            MichiButton("Secondary Filled", theme: .secondary, style: .filled) {}
            MichiButton("Pink Filled", theme: .pink, style: .filled) {}
            MichiButton("Blue Secondary Filled", theme: .blueSecondary, style: .filled) {}
            MichiButton("Purple Filled", theme: .purple, style: .filled) {}
            MichiButton("Yellow Orange Filled", theme: .yellowOrange, style: .filled) {}
            
            // Plain style
            MichiButton("Primary Plain", theme: .primary, style: .plain) {}
            MichiButton("Secondary Plain", theme: .secondary, style: .plain) {}
            MichiButton("Pink Plain", theme: .pink, style: .plain) {}
            MichiButton("Blue Secondary Plain", theme: .blueSecondary, style: .plain) {}
            MichiButton("Purple Plain", theme: .purple, style: .plain) {}
            MichiButton("Yellow Orange Plain", theme: .yellowOrange, style: .plain) {}
            
            // Bordered style
            MichiButton("Primary Bordered", theme: .primary, style: .bordered) {}
            MichiButton("Secondary Bordered", theme: .secondary, style: .bordered) {}
            MichiButton("Pink Bordered", theme: .pink, style: .bordered) {}
            MichiButton("Blue Secondary Bordered", theme: .blueSecondary, style: .bordered) {}
            MichiButton("Purple Bordered", theme: .purple, style: .bordered) {}
            MichiButton("Yellow Orange Bordered", theme: .yellowOrange, style: .bordered) {}
        }
        .padding()
    }
}

