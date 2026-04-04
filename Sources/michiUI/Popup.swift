//
//  Popup.swift
//  michiUI
//
//  Created by Angel Rodriguez on 4/4/26.
//

import SwiftUI

// MARK: - Button configuration

/// Configuration for a single action button in ``MichiPopup`` (up to two per popup).
public struct MichiPopupButton {
    public let title: String
    public let theme: MichiButton.Theme
    public let style: MichiButton.Style
    public let action: () -> Void

    public init(
        _ title: String,
        theme: MichiButton.Theme = .primary,
        style: MichiButton.Style = .filled,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.theme = theme
        self.style = style
        self.action = action
    }
}

/// How multiple action buttons are arranged in ``MichiPopup``.
public enum MichiPopupButtonLayout: Sendable {
    case horizontal
    case vertical
}

// MARK: - Popup content

/// Centered modal-style panel with optional header, image, subtitle, body, and up to two buttons.
///
/// Layout (top to bottom): header, image, subtitle, body, buttons.
/// Use ``View/michiPopup(isPresented:allowsBackdropDismiss:onDismiss:popup:)`` to present over a dimmed backdrop.
public struct MichiPopup: View {
    private let header: String?
    private let image: CardImage?
    private let subtitle: String?
    private let bodyText: String?
    private let primaryButton: MichiPopupButton?
    private let secondaryButton: MichiPopupButton?
    private let buttonLayout: MichiPopupButtonLayout

    /// - Parameter image: Use ``CardImage/image(_:)`` to pass a SwiftUI ``Image`` (e.g. `.image(Image(systemName: "star"))`).
    /// - Parameter buttonLayout: Side-by-side (``MichiPopupButtonLayout/horizontal``) or stacked (``MichiPopupButtonLayout/vertical``) when two buttons are shown.
    public init(
        header: String? = nil,
        image: CardImage? = nil,
        subtitle: String? = nil,
        bodyText: String? = nil,
        primaryButton: MichiPopupButton? = nil,
        secondaryButton: MichiPopupButton? = nil,
        buttonLayout: MichiPopupButtonLayout = .horizontal
    ) {
        self.header = header
        self.image = image
        self.subtitle = subtitle
        self.bodyText = bodyText
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.buttonLayout = buttonLayout
    }

    public init<V: View>(
        header: String? = nil,
        customImage: V? = nil,
        subtitle: String? = nil,
        bodyText: String? = nil,
        primaryButton: MichiPopupButton? = nil,
        secondaryButton: MichiPopupButton? = nil,
        buttonLayout: MichiPopupButtonLayout = .horizontal
    ) {
        self.header = header
        self.image = customImage.map { .anyView(AnyView($0)) }
        self.subtitle = subtitle
        self.bodyText = bodyText
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.buttonLayout = buttonLayout
    }

    public var body: some View {
        VStack(spacing: 16) {
            if let header {
                Text(header)
                    .font(.token(.titleMedium))
                    .foregroundStyle(Color.token(.black))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            if let image {
                popupImage(from: image)
                    .frame(maxWidth: 220)
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            if let subtitle {
                Text(subtitle)
                    .font(.token(.titleSmall))
                    .foregroundStyle(Color.token(.black))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            if let bodyText {
                Text(bodyText)
                    .font(.token(.body))
                    .foregroundStyle(Color.token(.black))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            if primaryButton != nil || secondaryButton != nil {
                buttonRow
            }
        }
        .padding(24)
        .frame(maxWidth: 340)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.token(.lightBeige))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.token(.black).opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.22), radius: 24, y: 12)
    }

    @ViewBuilder
    private var buttonRow: some View {
        switch (primaryButton, secondaryButton) {
        case (nil, nil):
            EmptyView()
        case let (primary?, nil):
            MichiButton(primary.title, theme: primary.theme, style: primary.style, action: primary.action)
                .frame(maxWidth: .infinity)
        case let (nil, secondary?):
            MichiButton(secondary.title, theme: secondary.theme, style: secondary.style, action: secondary.action)
                .frame(maxWidth: .infinity)
        case let (primary?, secondary?):
            twoButtonGroup(secondary: secondary, primary: primary)
        }
    }

    @ViewBuilder
    private func twoButtonGroup(secondary: MichiPopupButton, primary: MichiPopupButton) -> some View {
        switch buttonLayout {
        case .horizontal:
            HStack(spacing: 12) {
                MichiButton(secondary.title, theme: secondary.theme, style: secondary.style, action: secondary.action)
                    .frame(maxWidth: .infinity)
                MichiButton(primary.title, theme: primary.theme, style: primary.style, action: primary.action)
                    .frame(maxWidth: .infinity)
            }
        case .vertical:
            VStack(spacing: 12) {
                MichiButton(secondary.title, theme: secondary.theme, style: secondary.style, action: secondary.action)
                    .frame(maxWidth: .infinity)
                MichiButton(primary.title, theme: primary.theme, style: primary.style, action: primary.action)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    private func popupImage(from cardImage: CardImage) -> some View {
        switch cardImage {
        case .image(let image):
            image
                .resizable()
                .scaledToFit()
        case .anyView(let view):
            view
        }
    }
}

// MARK: - Presentation

private struct MichiPopupOverlayModifier: ViewModifier {
    @Binding var isPresented: Bool
    var allowsBackdropDismiss: Bool
    var onDismiss: (() -> Void)?
    let popup: () -> MichiPopup

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black.opacity(0.45)
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if allowsBackdropDismiss {
                                    isPresented = false
                                    onDismiss?()
                                }
                            }

                        popup()
                            .padding(.horizontal, 24)
                    }
                    .transition(.opacity)
                }
            }
            .animation(.spring(response: 0.38, dampingFraction: 0.88), value: isPresented)
    }
}

public extension View {
    /// Presents a ``MichiPopup`` centered on screen over a dimmed backdrop.
    /// - Parameters:
    ///   - isPresented: Whether the popup is visible.
    ///   - allowsBackdropDismiss: If true, tapping outside the card sets `isPresented` to `false`.
    ///   - onDismiss: Called when the backdrop dismisses the popup (not when buttons run their own actions).
    ///   - popup: The popup content.
    func michiPopup(
        isPresented: Binding<Bool>,
        allowsBackdropDismiss: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder popup: @escaping () -> MichiPopup
    ) -> some View {
        modifier(MichiPopupOverlayModifier(
            isPresented: isPresented,
            allowsBackdropDismiss: allowsBackdropDismiss,
            onDismiss: onDismiss,
            popup: popup
        ))
    }
}

#Preview("Popup content") {
    CustomFont.register()
    return ZStack {
        Color.token(.blueishSurface)
            .ignoresSafeArea()

        MichiPopup(
            header: "Heads up",
            image: .image(Image(systemName: "sparkles")),
            subtitle: "Something happened",
            bodyText: "You can dismiss with the button or by tapping outside.",
            primaryButton: MichiPopupButton("OK", action: {}),
            secondaryButton: MichiPopupButton("Cancel", theme: .secondary, style: .bordered, action: {})
        )
    }
}

#Preview("With modifier") {
    CustomFont.register()
    struct Host: View {
        @State private var show = true
        var body: some View {
            Color.token(.customTeal)
                .ignoresSafeArea()
                .michiPopup(isPresented: $show) {
                    MichiPopup(
                        header: "Title",
                        bodyText: "Body copy goes here.",
                        primaryButton: MichiPopupButton("Continue", action: { show = false })
                    )
                }
        }
    }
    return Host()
}
