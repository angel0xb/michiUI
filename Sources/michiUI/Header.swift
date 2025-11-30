//
//  Header.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//


import SwiftUI

public struct Header: View {
    
    public enum Style {
        case stacked
        case inline
    }
    
   public  enum Theme {
        case blue
        case pink
        case black
    }
    
    let title: AttributedString?
    let subtitle: AttributedString?
    let description: AttributedString?
    let style: Style
    let theme: Theme
    
    public init(title: AttributedString? = nil, subtitle: AttributedString? = nil, description: AttributedString? = nil, style: Style = .stacked, theme: Theme = .pink) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.style = style
        self.theme = theme
    }
    
    // Helper to get accent color based on theme
    private var accentColor: Color {
        switch theme {
        case .pink: .token(.pink)
        case .blue: .token(.blueAccent)
        case .black: .token(.black)
        }
    }
    
    // Helper to get background color based on theme
    private var backgroundColor: Color {
        switch theme {
        case .pink, .blue:
                .token(.orangeYellowSurface)
        case .black:
            .token(.customOrange)
        }
    }
    
 
    public var body: some View {
        switch style {
        case .inline: inline
        case .stacked: stacked
        }
    }
    
    var stacked: some View {
        VStack(alignment: .center, spacing: 8) {
            
            if let title {
                Text(title)
                    .font(.token(.titleMedium))
                    .multilineTextAlignment(.center)
//                    .lineLimit(3)
                    .foregroundColor(accentColor)
                    .padding(.bottom, subtitle == nil ? 0 : -14)
            }
            
            if let subtitle {
                Text(subtitle)
                    .font(.token(.titleSmall))
                    .multilineTextAlignment(.center)
//                    .lineLimit(3)
                    
            }
                
            if title != nil || subtitle != nil {
                dottedLine
                    .padding(.bottom, 8)
            }
            
            if let description {
                descriptionText(description)
            }
        }
        .padding()
        .background(backgroundColor)
    }
    
    var inline: some View {
        VStack(spacing: 8) {
            if title != nil || subtitle != nil {
                HStack {
                    if let title {
                        Text(title)
                            .font(.token(.titleLarge))
                            .lineLimit(1)
                            .foregroundColor(accentColor)
                    }
                    
                    if let subtitle {
                        Text(boldFirstLetter(subtitle))
                            .font(.token(.labelExtraLarge))
                    }
                }
            }
            
            if title != nil || subtitle != nil {
                dottedLine
                    .padding(.bottom, 8)
            }
            
            if let description {
                descriptionText(description)
            }
        }
        .padding()
        .background(backgroundColor)
    }
    
    func descriptionText(_ text: AttributedString) -> some View {
        Text(text)
            .font(.tokenLight(.labelSmall))
            .multilineTextAlignment(.center)
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    var dottedLine: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
            .foregroundColor(accentColor)
        }
        .frame(height: 2)
    }
    
    // Helper to bold the first letter of an AttributedString
    private func boldFirstLetter(_ attributedString: AttributedString) -> AttributedString {
        var result = attributedString
        
        // Find the first non-whitespace character by iterating through runs
        var firstCharStart: AttributedString.Index?
        var firstCharEnd: AttributedString.Index?
        
        var currentIndex = result.startIndex
        while currentIndex < result.endIndex {
            let char = result.characters[currentIndex]
            if !char.isWhitespace {
                firstCharStart = currentIndex
                firstCharEnd = result.index(afterCharacter: currentIndex)
                break
            }
            currentIndex = result.index(afterCharacter: currentIndex)
        }
        
        guard let start = firstCharStart, let end = firstCharEnd else {
            return result
        }
        
        // Apply bold trait to the first character
        var boldContainer = AttributeContainer()
        boldContainer.inlinePresentationIntent = .stronglyEmphasized
        
        result[start..<end].setAttributes(boldContainer)
        
        return result
    }
    
}


#Preview {
    CustomFont.register()
    return ScrollView {
        VStack {
            Header(title: "ナ ッ ク ル ズ ・ ザ ・ エ キ ド ゥ ナ",
                   subtitle: " 宙 ⼀ の ト レ ジ ャ ー ハ ン タ ー",
                   description:
                    """
                        エ ン ジ ェ ル ア イ ラ ン ド で 、 マ ス タ ー エ メ ラ ル
                         ド と 呼 ば れ る 巨 ⼤ な 宝 ⽯ を 守 っ て 暮 ら し て い る
                         ハ リ モ グ ラ 。 か つ て 、 D r . エ ッ グ マ ン に だ ま さ
                         れ て 、 ソ ニ ッ ク と 戦 っ た 経 験 も あ る 。 単 細 な 性
                    """,
                   style: .stacked,
                   theme: .pink
            )
            
            Header(title: "Knuckles the Echidna",
                   subtitle: "The greatest treasure hunter in the world.",
                   description:
                    "A echidna who lives on Angel Island, protecting the gigantic gemstone known as the Master Emerald. In the past, he was once deceived by Dr. Eggman and even fought Sonic. He has a simple-minded personality",
                   style: .stacked,
                   theme: .blue
            )
            
            Header(title: "Knuckles the Echidna",
                   subtitle: "The greatest treasure hunter in the world.",
                   description:
                    "A echidna who lives on Angel Island, protecting the gigantic gemstone known as the Master Emerald. In the past, he was once deceived by Dr. Eggman and even fought Sonic. He has a simple-minded personality",
                   style: .stacked,
                   theme: .black
            )
            
            Header(title: "Knuckles the Echidna",
                   description:
                    "A echidna who lives on Angel Island, protecting the gigantic gemstone known as the Master Emerald. In the past, he was once deceived by Dr. Eggman and even fought Sonic. He has a simple-minded personality",
                   style: .stacked,
                   theme: .pink
            )
            
            Header(
                subtitle: "The greatest treasure hunter in the world.",
                   description:
                    "A echidna who lives on Angel Island, protecting the gigantic gemstone known as the Master Emerald. In the past, he was once deceived by Dr. Eggman and even fought Sonic. He has a simple-minded personality",
                   style: .stacked,
                   theme: .pink
            )
            Header(title: "チ ャ オ ",
                   subtitle: try! AttributedString(markdown:"**C**hao"),
                   description:
                    """
                        エ ン ジ ェ ル ア イ ラ ン ド で 、 マ ス タ ー エ メ ラ ル
                         ド と 呼 ば れ る 巨 ⼤ な 宝 ⽯ を 守 っ て 暮 ら し て い る
                         ハ リ モ グ ラ 。 か つ て 、 D r . エ ッ グ マ ン に だ ま さ
                         れ て 、 ソ ニ ッ ク と 戦 っ た 経 験 も あ る 。 単 細 な 性
                    """,
                   style: .inline,
                   theme: .blue
            )
            .dottedBorder(
                cornerRadius: 12,
                lineWidth: 3,
                dashLength: 6,
                gapLength: 4,
                color: .blue
            )
            .padding(.horizontal)
            
            Header(title: "Title",
                   subtitle: "Chao",
                   description:
                    """
                    To access the Chao Lobby, pick up a Chao Key from one of the Chao Boxes in any of the game's stages. Upon completing the stage, you're automatically transported to the Chao Lobby. From there, you'll find the entrance to both the Chao Garden and the Kindergarten.
                    """,
                   style: .inline,
                   theme: .blue
            )
            .dottedBorder(
                cornerRadius: 12,
                lineWidth: 3,
                dashLength: 6,
                gapLength: 4,
                color: .blue
            )
            .padding(.horizontal)
            
            Header(
                   subtitle: "Chao",
                   description:
                    """
                    To access the Chao Lobby, pick up a Chao Key from one of the Chao Boxes in any of the game's stages. Upon completing the stage, you're automatically transported to the Chao Lobby. From there, you'll find the entrance to both the Chao Garden and the Kindergarten.
                    """,
                   style: .inline,
                   theme: .blue
            )
            .dottedBorder(
                cornerRadius: 12,
                lineWidth: 3,
                dashLength: 6,
                gapLength: 4,
                color: .blue
            )
            .padding(.horizontal)
            Spacer()
        }
    }
    
}
