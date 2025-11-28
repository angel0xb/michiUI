//
//  Header.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//


import SwiftUI

public struct Header: View {
    
    enum Style {
        case stacked
        case inline
    }
    
    enum Theme {
        case blue
        case pink
    }
    
    let title: AttributedString?
    let subtitle: AttributedString?
    let description: AttributedString?
    let style: Style
    let theme: Theme
    
    init(title: AttributedString? = nil, subtitle: AttributedString? = nil, description: AttributedString? = nil, style: Style = .stacked, theme: Theme = .pink) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.style = style
        self.theme = theme
    }
    
    // Helper to get accent color based on theme
    private var accentColor: Color {
        switch theme {
        case .pink:
            return .token(.pink)
        case .blue:
            return .token(.blueAccent)
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
            
            if let title = title {
                Text(title)
                    .font(.token(.titleMedium))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .foregroundColor(accentColor)
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.token(.titleMedium))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
                
            if title != nil || subtitle != nil {
                dottedLine
                    .padding(.bottom, 8)
            }
            
            if let description = description {
                Text(description)
                    .font(.token(.labelSmall))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.token(.orangeYellowSurface))
    }
    
    var inline: some View {
        VStack(spacing: 8) {
            if title != nil || subtitle != nil {
                HStack {
                    if let title = title {
                        Text(title)
                            .font(.token(.titleLarge))
                            .lineLimit(1)
                            .foregroundColor(accentColor)
                    }
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.token(.labelExtraLarge))
                    }
                }
            }
            
            if title != nil || subtitle != nil {
                dottedLine
                    .padding(.bottom, 8)
            }
            
            if let description = description {
                Text(description)
                    .font(.token(.labelSmall))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.token(.orangeYellowSurface))
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
    
    // Helper to create AttributedString with markdown and preserve font
    private func attributedMarkdown(_ markdown: String, font: Font) -> AttributedString {
        var attributedString = try! AttributedString(markdown: markdown)
        
        // Apply font to the entire string
        // Since we're using font family names, SwiftUI should automatically
        // use the bold variant for text that markdown made bold
        var fontContainer = AttributeContainer()
        fontContainer.font = font
        
        // Apply to entire string - the font family approach should preserve bold
        attributedString.setAttributes(fontContainer)
        
        return attributedString
    }
}


#Preview {
    CustomFont.register()
    return VStack {
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
        Divider()
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
        Spacer()
    }
    
}
