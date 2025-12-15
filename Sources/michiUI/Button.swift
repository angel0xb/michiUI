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
        case green
        case lightGreen
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
    
    @State private var isPressed = false
    @State private var hapticTrigger = false
    
    // 3D effect offset - button moves down when pressed
    private var offsetY: CGFloat {
        isPressed ? 0 : -8
    }
    
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
        case .green: .green
        case .lightGreen: .lightGreen
        }
    }
    
    public var body: some View {
        ZStack {
            // Shadow layer (darker, behind) - only for filled style
            if style == .filled {
                shadowLayer
            }
            
            // Main button layer (moves up when not pressed)
            Button(action: {
                hapticTrigger.toggle()
                action()
            }) {
                buttonContent
            }
            .buttonStyle(PlainButtonStyle())
            .offset(y: offsetY)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.spring(.snappy(duration: 0.05))) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(.snappy(duration: 0.05))) {
                            isPressed = false
                        }
                    }
            )
            .sensoryFeedback(.selection, trigger: hapticTrigger)
        }
    }
    
    // Shadow layer for 3D effect
    @ViewBuilder
    private var shadowLayer: some View {
        let shadowContent = Text(" ")
            .font(.token(.titleSmall))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(backgroundColor.opacity(0.7))
            .padding(2)
            .dottedBorder(
                cornerRadius: 21,
                lineWidth: 5,
                dashLength: 16,
                gapLength: 0,
                color: .token(.tealSecondary)
            )
            .clipShape(.capsule)
            .padding(2)
        
        shadowContent
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
                .clipShape(.capsule/*RoundedRectangle(cornerRadius: 16)*/)
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
            return (theme == .yellowOrange || theme == .lightGreen) ? .token(.black) : .white
        case .plain, .bordered:
            return Color.token(themeColor)
        }
    }
}

// MARK: - View Modifiers

public struct ButtonThemeModifier: ViewModifier {
    let theme: MichiButton.Theme
    let style: MichiButton.Style?
    let title: String
    let action: () -> Void
    
    public func body(content: Content) -> some View {
        MichiButton(
            title,
            theme: theme,
            style: style ?? .filled,
            action: action
        )
    }
}

public extension View {
    /// Modifies the button's theme and optionally its style
    /// - Parameters:
    ///   - theme: The new theme to apply
    ///   - style: Optional new style to apply (nil keeps current style)
    ///   - title: The button title
    ///   - action: The button action
    /// - Returns: A new button with the specified theme and style
    func buttonTheme(
        _ theme: MichiButton.Theme,
        style: MichiButton.Style? = nil,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        modifier(ButtonThemeModifier(theme: theme, style: style, title: title, action: action))
    }
}

public extension MichiButton {
    /// Returns a new button with a different theme
    /// - Parameter theme: The new theme to apply
    /// - Returns: A new button with the updated theme
    func theme(_ theme: Theme) -> MichiButton {
        MichiButton(title, theme: theme, style: style, action: action)
    }
    
    /// Returns a new button with a different style
    /// - Parameter style: The new style to apply
    /// - Returns: A new button with the updated style
    func style(_ style: Style) -> MichiButton {
        MichiButton(title, theme: theme, style: style, action: action)
    }
    
    /// Returns a new button with both theme and style changed
    /// - Parameters:
    ///   - theme: The new theme to apply
    ///   - style: The new style to apply
    /// - Returns: A new button with the updated theme and style
    func theme(_ theme: Theme, style: Style) -> MichiButton {
        MichiButton(title, theme: theme, style: style, action: action)
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
            MichiButton("Green Filled", theme: .green, style: .filled) {}
            MichiButton("Light Green Filled", theme: .lightGreen, style: .filled) {}
            
            // Plain style
            MichiButton("Primary Plain", theme: .primary, style: .plain) {}
            MichiButton("Secondary Plain", theme: .secondary, style: .plain) {}
            MichiButton("Pink Plain", theme: .pink, style: .plain) {}
            MichiButton("Blue Secondary Plain", theme: .blueSecondary, style: .plain) {}
            MichiButton("Purple Plain", theme: .purple, style: .plain) {}
            MichiButton("Yellow Orange Plain", theme: .yellowOrange, style: .plain) {}
            MichiButton("Green Plain", theme: .green, style: .plain) {}
            MichiButton("Light Green Plain", theme: .lightGreen, style: .plain) {}
            
            // Bordered style
            MichiButton("Primary Bordered", theme: .primary, style: .bordered) {}
            MichiButton("Secondary Bordered", theme: .secondary, style: .bordered) {}
            MichiButton("Pink Bordered", theme: .pink, style: .bordered) {}
            MichiButton("Blue Secondary Bordered", theme: .blueSecondary, style: .bordered) {}
            MichiButton("Purple Bordered", theme: .purple, style: .bordered) {}
            MichiButton("Yellow Orange Bordered", theme: .yellowOrange, style: .bordered) {}
            MichiButton("Green Bordered", theme: .green, style: .bordered) {}
            MichiButton("Light Green Bordered", theme: .lightGreen, style: .bordered) {}
        }
        .padding()
    }
}

