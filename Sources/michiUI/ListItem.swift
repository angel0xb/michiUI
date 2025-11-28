//
//  ListItem.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI

public struct ListItem: View {
    let number: Int
    let text: String
    let colorToken: ColorToken
    
    public init(number: Int, text: String, colorToken: ColorToken = .customTeal) {
        self.number = number
        self.text = text
        self.colorToken = colorToken
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Text("\(number)")
                .font(.token(.titleSmall))
                .padding(.leading)
                .padding(.trailing, 10)
                .background(Color.token(colorToken))
                .clipShape(Capsule())
                .foregroundStyle(.white)
            
            Text(text)
                .font(.token(.titleExtraSmall))
                .foregroundStyle(Color.token(colorToken))
        }
        .padding(.trailing, 10)
        .background(Color.clear)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.token(colorToken), lineWidth: 2)
        )
    }
}

#Preview {
    CustomFont.register()
    return VStack(spacing: 10) {
        ListItem(number: 1, text: "Hello World!", colorToken: .customTeal)
        
        ListItem(number: 2, text: "second item", colorToken: .customPurple)
        
        ListItem(number: 3, text: "third item", colorToken: .customOrange)
        
        ListItem(number: 100, text: "big mode long text for this one", colorToken: .pinkAccent)
        
        ListItem(number: 5, text: "default color", colorToken: .customTeal)
    }
}
