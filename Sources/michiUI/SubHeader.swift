//
//  SubHeader.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI

public struct SubHeader: View {
    
    let text: String
    let subText: String?
    let theme: Theme
    let subtitle: String?
    let description: String?
    
    public enum Theme {
        case primary
        case secondary
        case pink
        case blueSecondary
    }
    
    
   public  init(text: String, subText: String? = nil, subtitle: String? = nil, description: String? = nil, theme: Theme = .primary) {
        self.text = text
        self.subText = subText
        self.theme = theme
        self.subtitle = subtitle
        self.description = description
    }
    
    private var textBackgroundColor: ColorToken {
        switch theme {
        case .primary:
            return .customTeal
        case .secondary:
            return .tealSecondary
        case .pink:
            return subText != nil ? .customTeal : .pinkAccent
        case .blueSecondary:
            return subText != nil ? .customTeal : .blueSecondary
        }
    }
    
    private var subTextBackgroundColor: ColorToken {
        switch theme {
        case .primary:
            return .tealSecondary
        case .secondary:
            return .customTeal
        case .pink:
            return .pinkAccent
        case .blueSecondary:
            return .blueSecondary
        }
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: subText != nil ? -16 : 0) {
                Text(text)
                    .font(.token(.titleExtraSmall))
                    .padding(.horizontal, 10)
                    .background(Color.token(textBackgroundColor))
                    .clipShape(Capsule())
                    .zIndex(1)
                
                if let subText {
                    Text(subText)
                        .font(.token(.titleExtraSmall))
                        .padding(.trailing, 10)
                        .padding(.leading, 22)
                        .background(Color.token(subTextBackgroundColor))
                        .clipShape(Capsule())
                }
            }
            .foregroundStyle(.white)
            
            if subtitle != nil || description != nil {
                VStack {
                    if let subtitle {
                        Text(subtitle)
                            .font(.token(.labelExtraLarge))
                    }
                    
                    if let description {
                        Text(description)
                            .font(.token(.labelExtraSmall))
                            .foregroundStyle(Color.token(.customTeal))
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: 200)
            }
            
        }
        
        
    }
}

#Preview {
    CustomFont.register()
   return VStack(spacing: 20) {
        SubHeader(text: "TEST")
       SubHeader(text: "TEST", theme: .secondary)
       SubHeader(text: "TEST", theme: .pink)
       SubHeader(text: "TEST", theme: .blueSecondary)
       
       SubHeader(text: "TEST", subText: "sub text", theme: .primary)
       SubHeader(text: "TEST", subText: "sub text", theme: .secondary)
       SubHeader(text: "TEST", subText: "sub text", theme: .pink)
       SubHeader(text: "TEST", subText: "sub text", theme: .blueSecondary)
       
       
       SubHeader(
        text: "TEST",
        subText: "sub text",
        subtitle: "this is a subtitle",
        description: "some text for description should wrap if its too long so that it fits under",
        theme: .primary
       )
       
       
       SubHeader(
        text: "banana",
        subText: "100",
        subtitle: "fruit",
        description: "some text for description should wrap if its too long so that it fits under",
        theme: .primary
       )
       
       SubHeader(
        text: "power",
        subText: "100"
       )
       SubHeader(
        text: "fly",
        subText: "30"
       )
       
       SubHeader(
        text: "run",
        subText: "100",
        theme: .pink
       )
       
       SubHeader(
        text: "mood",
        subText: "1/10",
        theme: .pink
       )
    }
}
