//
//  Card.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/28/25.
//

import SwiftUI

public enum CardVariant {
    case pink
    case yellow
}

public enum CardImage {
    case image(Image)
    case anyView(AnyView)
    
    public init(_ image: Image) {
        self = .image(image)
    }
    
    public init<V: View>(_ view: V) {
        self = .anyView(AnyView(view))
    }
}

public struct Card: View {
    var title: String?
    var subtitle: String?
    var image: CardImage?
    var bulletedList: [String] = []
    var variant: CardVariant = .pink
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        image: CardImage? = nil,
        bulletedList: [String] = [],
        variant: CardVariant = .pink
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.bulletedList = bulletedList
        self.variant = variant
    }
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        image: Image? = nil,
        bulletedList: [String] = [],
        variant: CardVariant = .pink
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image.map { .image($0) }
        self.bulletedList = bulletedList
        self.variant = variant
    }
    
    public init<V: View>(
        title: String? = nil,
        subtitle: String? = nil,
        customView: V? = nil,
        bulletedList: [String] = [],
        variant: CardVariant = .pink
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = customView.map { .anyView(AnyView($0)) }
        self.bulletedList = bulletedList
        self.variant = variant
    }
   
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                titleSection(title)
                    .padding(.horizontal)
                    
            }
            
            if image != nil || subtitle != nil {
                subTitleSection(subtitle ?? "")
                    .padding(.horizontal)
                    
            }
            
            // dotted line
            DottedLine()
                .fill(Color.token(.black))
                .frame(height: 2)
                .padding(.horizontal)
                
            VStack(alignment: .leading, spacing: 0) {
                ForEach(bulletedList, id: \.self) { item in
                    bulletItem(item)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(backgroundColor)
        .cornerRadius(16)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    var backgroundColor: Color {
        switch variant {
        case .pink: Color.token(.pink)
        case .yellow:  Color.token(.orangeYellowSurface)
        }
    }
    
    var titleBarColor: Color {
        switch variant {
        case .pink: Color.token(.tealSecondary)
        case .yellow: Color.token(.pinkAccent)
        }
    }
    
    var subtitleBarColor: Color {
        switch variant {
        case .pink:  Color.token(.orangeYellowSurface)
        case .yellow: Color.token(.customOrange)
        }
    }
    
    var titleTextColor: Color {
        switch variant {
        case .pink: .white
        case .yellow: Color.token(.black)
        }
    }
    
    var bulletColor: Color {
        switch variant {
        case .pink: .white
        case .yellow: Color.token(.customTeal)
        }
    }
    
    func titleSection(_ title: String) -> some View {
        HStack(spacing: 3) {
            titleBarColor
                .frame(width: 4)
            
            Text(title)
                .font(.token(.titleMedium))
        }
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(titleTextColor)
    }
    
    func subTitleSection(_ text: String) -> some View {
        HStack(alignment: .top) {
            if let image {
                imageView(from: image)
                    .frame(width: 80, height: 80)
            }
            
            if let subtitle {
                HStack(spacing: 3) {
                    subtitleBarColor
                        .frame(width: 5)
                    
                    Text(subtitle)
                        .font(.token(.titleMedium))
                        .foregroundStyle(titleTextColor)
                }
                .fixedSize()
            }
        }
    }
    
    @ViewBuilder
    func imageView(from cardImage: CardImage) -> some View {
        switch cardImage {
        case .image(let image):
            image
                .resizable()
        case .anyView(let view):
            view
        }
    }
    
    func bulletItem(_ text: String) -> some View {
        HStack(spacing: 2) {
            Circle()
                .frame(width: 12, height: 12)
            
            Text(text)
                .font(.token(.labelLarge))
        }
        .foregroundStyle(bulletColor)
    
    }
}

#Preview {
    CustomFont.register()
    return ScrollView {
        VStack {
            // Using Image directly (convenience initializer)
            Card(
                title: "Title",
                subtitle: "subTitle",
                image: Image(systemName: "photo.artframe"),
                bulletedList: ["first bullet", "second bullet", "third bullet", "fourth bullet", "fifth bullet"]
            )
            
            // Yellow variant with Image
            Card(
                title: "Title",
                subtitle: "subTitle",
                image: Image(systemName: "photo.artframe"),
                bulletedList: ["first bullet", "second bullet", "third bullet", "fourth bullet", "fifth bullet"],
                variant: .yellow
            )
            
            // Using CardImage enum directly
            Card(
                title: "Title",
                subtitle: "longer subtitle",
                image: .image(Image(systemName: "photo.artframe")),
                bulletedList: ["first bullet", "second bullet"]
            )
            
            // Using customView initializer for AnyView
            Card(
                title: "Title",
                subtitle: "subTitle",
                customView: Text("Custom View"),
                bulletedList: ["first bullet", "second bullet"]
            )
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
