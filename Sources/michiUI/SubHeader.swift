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
    
    enum Theme {
        case primary
        case secondary
    }
    
    
    init(text: String, subText: String? = nil, subtitle: String? = nil, description: String? = nil, theme: Theme = .primary) {
        self.text = text
        self.subText = subText
        self.theme = theme
        self.subtitle = subtitle
        self.description = description
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: subText != nil ? -16 : 0) {
                Text(text)
                    .font(.token(.titleExtraSmall))
                    .padding(.horizontal)
                    .background(Color.token(theme == .primary ? .customTeal : .tealSecondary))
                    .clipShape(Capsule())
                    .zIndex(1)
                
                if let subText {
                    Text(subText)
                        .font(.token(.titleExtraSmall))
                        .padding(.trailing)
                        .padding(.leading, 22)
                        .background(Color.token(theme == .primary ? .tealSecondary : .customTeal))
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
       
       SubHeader(text: "TEST", subText: "sub text", theme: .primary)
       SubHeader(text: "TEST", subText: "sub text", theme: .secondary)
       
       
       SubHeader(text: "TEST", subText: "sub text", subtitle: "this is a subtitle", description: "some text for description should wrap if its too long so that it fits under",theme: .primary)
    }
}
