//
//  Chip.swift
//  michiUI
//
//  Created by Angel Rodriguez on 3/31/26.
//

import SwiftUI

// MARK: - Content

/// What each chip displays: label only, icon only, or both.
public enum MichiChipContent: Equatable {
    case text(String)
    case image(Image)
    case imageAndText(image: Image, text: String)
}

// MARK: - Option

/// One selectable chip in a `MichiChipGroup`.
public struct MichiChipOption<ID: Hashable>: Identifiable {
    public let id: ID
    public let content: MichiChipContent
    public let accessibilityLabel: String?

    /// - Parameters:
    ///   - id: Stable identifier used with the selection binding.
    ///   - text: Visible title.
    ///   - accessibilityLabel: Overrides VoiceOver label when non-nil.
    public init(id: ID, text: String, accessibilityLabel: String? = nil) {
        self.id = id
        self.content = .text(text)
        self.accessibilityLabel = accessibilityLabel
    }

    /// - Parameters:
    ///   - id: Stable identifier used with the selection binding.
    ///   - image: Icon or asset image (use a fixed frame in callers if needed).
    ///   - accessibilityLabel: Required for meaningful VoiceOver on image-only chips.
    public init(id: ID, image: Image, accessibilityLabel: String?) {
        self.id = id
        self.content = .image(image)
        self.accessibilityLabel = accessibilityLabel
    }

    /// - Parameters:
    ///   - id: Stable identifier used with the selection binding.
    ///   - image: Leading image.
    ///   - text: Visible title.
    ///   - accessibilityLabel: Overrides VoiceOver when non-nil (defaults to `text`).
    public init(id: ID, image: Image, text: String, accessibilityLabel: String? = nil) {
        self.id = id
        self.content = .imageAndText(image: image, text: text)
        self.accessibilityLabel = accessibilityLabel
    }
}

// MARK: - Variant

/// Preset chip colors (aligned with `MichiButton.Theme`); use `.custom` for any `ColorToken`.
public enum MichiChipVariant: Equatable {
    case primary
    case secondary
    case pink
    case blueSecondary
    case purple
    case yellowOrange
    case green
    case lightGreen
    case custom(ColorToken)
}

extension MichiChipVariant {
    fileprivate var accentToken: ColorToken {
        switch self {
        case .primary: .customTeal
        case .secondary: .tealSecondary
        case .pink: .pinkAccent
        case .blueSecondary: .blueSecondary
        case .purple: .purpleAccent
        case .yellowOrange: .yellowOrangeSecondary
        case .green: .green
        case .lightGreen: .lightGreen
        case .custom(let token): token
        }
    }

    /// Foreground color when the chip is selected (filled).
    fileprivate var selectedForeground: Color {
        switch self {
        case .yellowOrange, .lightGreen:
            return .token(.black)
        case .primary, .secondary, .pink, .blueSecondary, .purple, .green, .custom:
            return .white
        }
    }
}

// MARK: - Group

/// Chip group laid out horizontally or vertically; at most one option is selected at a time.
public struct MichiChipGroup<ID: Hashable>: View {
    private let options: [MichiChipOption<ID>]
    @Binding private var selection: ID?
    private let variant: MichiChipVariant
    private let axis: Axis
    private let scrolls: Bool

    @State private var selectionFeedback = false

    /// - Parameters:
    ///   - options: One or more chips (each needs a unique `id`).
    ///   - selection: The selected chip id, or `nil` when nothing is selected.
    ///   - variant: Color preset for border and selected fill (see `MichiChipVariant`).
    ///   - axis: `.horizontal` lays out chips in a row; `.vertical` stacks them.
    ///   - scrolls: When `true`, wraps the stack in a `ScrollView` along `axis` for overflow.
    public init(
        options: [MichiChipOption<ID>],
        selection: Binding<ID?>,
        variant: MichiChipVariant = .primary,
        axis: Axis = .horizontal,
        scrolls: Bool = true
    ) {
        self.options = options
        self._selection = selection
        self.variant = variant
        self.axis = axis
        self.scrolls = scrolls
    }

    /// Uses a specific `ColorToken` as the accent (same as `variant: .custom(token)`).
    public init(
        options: [MichiChipOption<ID>],
        selection: Binding<ID?>,
        accent: ColorToken,
        axis: Axis = .horizontal,
        scrolls: Bool = true
    ) {
        self.options = options
        self._selection = selection
        self.variant = .custom(accent)
        self.axis = axis
        self.scrolls = scrolls
    }

    public var body: some View {
        Group {
            if scrolls {
                switch axis {
                case .horizontal:
                    ScrollView(.horizontal, showsIndicators: false) {
                        chipStack
                    }
                case .vertical:
                    ScrollView(.vertical, showsIndicators: false) {
                        chipStack
                    }
                }
            } else {
                chipStack
            }
        }
        .sensoryFeedback(.selection, trigger: selectionFeedback)
    }

    @ViewBuilder
    private var chipStack: some View {
        switch axis {
        case .horizontal:
            HStack(spacing: 8) {
                chips
            }
        case .vertical:
            VStack(alignment: .leading, spacing: 8) {
                chips
            }
        }
    }

    @ViewBuilder
    private var chips: some View {
        ForEach(options) { option in
            MichiChipCell(
                content: option.content,
                isSelected: selection == option.id,
                accent: variant.accentToken,
                unselectedForeground: Color.token(variant.accentToken),
                selectedForeground: variant.selectedForeground,
                accessibilityLabel: resolvedAccessibilityLabel(for: option)
            ) {
                selection = option.id
                selectionFeedback.toggle()
            }
        }
    }

    private func resolvedAccessibilityLabel(for option: MichiChipOption<ID>) -> String {
        if let label = option.accessibilityLabel { return label }
        switch option.content {
        case .text(let s), .imageAndText(_, let s):
            return s
        case .image:
            return ""
        }
    }
}

// MARK: - Cell

private struct MichiChipCell: View {
    let content: MichiChipContent
    let isSelected: Bool
    let accent: ColorToken
    let unselectedForeground: Color
    let selectedForeground: Color
    let accessibilityLabel: String
    let action: () -> Void

    private static let imageSide: CGFloat = 20

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                switch content {
                case .text(let title):
                    Text(title)
                case .image(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: Self.imageSide, height: Self.imageSide)
                case .imageAndText(let image, let title):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: Self.imageSide, height: Self.imageSide)
                    Text(title)
                }
            }
            .font(.token(.labelMedium))
            .foregroundStyle(isSelected ? selectedForeground : unselectedForeground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.token(accent) : Color.clear)
            )
            .overlay(
                Capsule()
                    .stroke(Color.token(accent), lineWidth: 2)
            )
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(accessibilityLabel.isEmpty ? "Chip" : accessibilityLabel))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview("MichiChipGroup") {
    CustomFont.register()
    struct PreviewHost: View {
        @State private var selected: String?

        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                MichiChipGroup(
                    options: [
                        MichiChipOption(id: "a", text: "Cats"),
                        MichiChipOption(id: "b", text: "Dogs"),
                        MichiChipOption(id: "c", image: Image(systemName: "bird.fill"), accessibilityLabel: "Birds"),
                        MichiChipOption(
                            id: "d",
                            image: Image(systemName: "fish.fill"),
                            text: "Fish"
                        ),
                    ],
                    selection: $selected
                )

                MichiChipGroup(
                    options: [
                        MichiChipOption(id: "v1", text: "One"),
                        MichiChipOption(id: "v2", text: "Two"),
                        MichiChipOption(id: "v3", text: "Three"),
                    ],
                    selection: $selected,
                    variant: .pink,
                    axis: .vertical,
                    scrolls: false
                )
                .frame(maxWidth: 200)

                MichiChipGroup(
                    options: [
                        MichiChipOption(id: "p1", text: "Accent"),
                        MichiChipOption(id: "p2", text: "Tokens"),
                    ],
                    selection: $selected,
                    accent: .mexicanPink,
                    scrolls: false
                )

                Text("Selection: \(selected ?? "nil")")
                    .font(.token(.labelSmall))
                    .foregroundStyle(Color.token(.tealSecondary))
            }
            .padding()
        }
    }
    return PreviewHost()
}
