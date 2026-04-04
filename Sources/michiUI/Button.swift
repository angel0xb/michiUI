//
//  Button.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI
import UIKit

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

    private var offsetY: CGFloat {
        isPressed ? 0 : -4
    }

    private var pressScale: CGFloat {
        isPressed ? 0.98 : 1
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
            if style == .filled {
                shadowLayer
            }

            Button(action: {
                hapticTrigger.toggle()
                action()
            }) {
                buttonContent
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(pressScale)
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

    @ViewBuilder
    private var shadowLayer: some View {
        Text(" ")
            .font(.token(.titleSmall))
            .foregroundStyle(.clear)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(aquaShadowColor.opacity(isPressed ? 0.12 : 0.28))
            )
            .blur(radius: isPressed ? 3 : 6)
            .offset(y: isPressed ? 2 : 6)
    }

    @ViewBuilder
    private var buttonContent: some View {
        let baseContent = Text(title)
            .font(.token(.titleSmall))
            .foregroundStyle(textColor)
            .shadow(color: filledTextShadowColor, radius: 0, x: 0, y: 1)

        if style != .plain {
            baseContent
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    if style == .filled {
                        aquaFilledBackground
                    } else {
                        Color.clear
                    }
                }
                .overlay {
                    if style == .bordered {
                        Capsule()
                            .stroke(Color.token(themeColor).opacity(0.9), lineWidth: 2)
                    }
                }
                .clipShape(Capsule())
        } else {
            baseContent
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
    }

    private var aquaFilledBackground: some View {
        let stroke = aquaStrokeColor
        let g = aquaGradient

        return ZStack {
            Capsule()
                .fill(g)
                .overlay {
                    Capsule()
                        .strokeBorder(stroke, lineWidth: 1)
                }

            // Top gloss (classic Aqua highlight)
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(isPressed ? 0.22 : 0.42),
                                .white.opacity(0.08),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w - 6, height: h * 0.52)
                    .position(x: w / 2, y: h * 0.28)
                    .blur(radius: 0.5)
            }
            .allowsHitTesting(false)

            // Subtle inner edge darkening (depth)
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .black.opacity(isPressed ? 0.12 : 0.06),
                            .clear,
                            .black.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .padding(1)
                .allowsHitTesting(false)
        }
        .brightness(isPressed ? -0.06 : 0)
    }

    private var aquaGradient: LinearGradient {
        switch theme {
        case .primary:
            return LinearGradient(
                colors: [
                    Color(red: 0.52, green: 0.78, blue: 1.0),
                    Color(red: 0.28, green: 0.58, blue: 0.98),
                    Color(red: 0.12, green: 0.42, blue: 0.92)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .secondary:
            return LinearGradient(
                colors: [
                    Color.token(.lightTeal),
                    Color.token(.customTeal),
                    Color.token(.tealSecondary)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .pink:
            return LinearGradient(
                colors: [
                    Color.token(.lightPinkAccent),
                    Color.token(.pinkAccent),
                    Color.token(.mexicanPink)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .blueSecondary:
            return LinearGradient(
                colors: [
                    Color.token(.lightBlueAccent),
                    Color.token(.blueSecondary),
                    Color.token(.customDarkBlue)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .purple:
            return LinearGradient(
                colors: [
                    Color.token(.purpleSurface),
                    Color.token(.purpleAccent),
                    Color.token(.customPurple)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .yellowOrange:
            return LinearGradient(
                colors: [
                    Color.token(.orangeYellowSurface),
                    Color.token(.yellowOrange),
                    Color.token(.yellowOrangeSecondary)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .green:
            return LinearGradient(
                colors: [
                    Color.token(.lightGreen),
                    Color.token(.green),
                    Color(red: 0.05, green: 0.45, blue: 0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .lightGreen:
            return LinearGradient(
                colors: [
                    Color.token(.lightBeige),
                    Color.token(.lightGreen),
                    Color.token(.green)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var aquaStrokeColor: Color {
        switch theme {
        case .primary:
            return Color(red: 0.04, green: 0.22, blue: 0.62)
        default:
            return Color.token(themeColor).opacity(0.55).mix(with: .black, amount: 0.35)
        }
    }

    private var aquaShadowColor: Color {
        switch theme {
        case .primary:
            return Color(red: 0.35, green: 0.65, blue: 0.95)
        default:
            return Color.token(themeColor).opacity(0.6)
        }
    }

    private var filledTextShadowColor: Color {
        switch style {
        case .filled:
            return Color.black.opacity(0.35)
        default:
            return .clear
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

// MARK: - Color mixing (Aqua stroke)

private extension Color {
    func mix(with other: Color, amount: Double) -> Color {
        let ui = UIColor(self)
        let o = UIColor(other)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        ui.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        o.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let t = CGFloat(amount)
        return Color(
            red: Double(r1 + (r2 - r1) * t),
            green: Double(g1 + (g2 - g1) * t),
            blue: Double(b1 + (b2 - b1) * t),
            opacity: Double(a1 + (a2 - a1) * t)
        )
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
            MichiButton("Aqua Button", theme: .primary, style: .filled) {}

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
