//
//  TokenSystem.swift
//  michiUI
//
//  Created by Angel Rodriguez on 11/27/25.
//

import SwiftUI
import UIKit
import CoreText

/// Token-based design system for fonts and colors
///
/// **Important:** Call `CustomFont.register()` during app initialization to register custom fonts.
///
/// Usage examples:
/// ```swift
/// // In your App's init or onAppear:
/// CustomFont.register()
///
/// // Then use tokens:
/// Text("Hello")
///     .font(.token(.titleLarge))
///     .foregroundStyle(.token(.pink))
///
/// Text("Label")
///     .font(.token(.labelMedium))
///     .foregroundStyle(.token(.blueAccent))
/// ```

// MARK: - Font Tokens

/// Font token types
/// Titles use Microgramma D Extended Bold
/// Labels use Karu Font Family
public enum FontToken {
    // Title fonts (Microgramma D Extended Bold)
    case titleLarge
    case titleMedium
    case titleSmall
    case titleExtraLarge
    case titleExtraSmall
    case titleTiny
    case title(size: CGFloat)
    
    // Label fonts (Karu Font Family)
    case labelLarge
    case labelMedium
    case labelSmall
    case labelExtraLarge
    case labelExtraSmall
    case labelTiny
    case body
    case caption
}

// MARK: - Color Tokens

/// Color token types matching asset catalog colors
public enum ColorToken {
    case black
    case blueAccent
    case blueishSurface
    case blueSecondary
    case customBlue
    case customDarkBlue
    case customOrange
    case customPurple
    case customTeal
    case green
    case lightBeige
    case lightBlueAccent
    case lightGreen
    case lightPinkAccent
    case lightTeal
    case orangeYellowSurface
    case peach
    case pinkAccent
    case purpleAccent
    case purpleSurface
    case tealContainer
    case tealSecondary
    case warning
    case yellowOrangeSecondary
    case pink // Alias for pinkAccent
}

// MARK: - Font Registration

/// Custom font registration utility
/// Call `CustomFont.register()` in your app's initialization to register custom fonts
public struct CustomFont {
    private nonisolated(unsafe) static var isRegistered = false
    
    /// Registers custom fonts from the bundle
    /// Call this method once during app initialization (e.g., in App's init or onAppear)
    public static func register() {
        guard !isRegistered else { return }
        isRegistered = true
        
        print("=== Font Registration Debug ===")
        
        // Register Microgramma font - try different paths
        if let fontURL = Bundle.module.url(forResource: "Microgramma D Extended Bold", withExtension: "otf") {
            registerFont(at: fontURL, name: "Microgramma")
        } else if let fontURL = Bundle.module.url(forResource: "Microgramma D Extended Bold", withExtension: "otf", subdirectory: "Fonts") {
            registerFont(at: fontURL, name: "Microgramma")
        }
        
        // Register Karu fonts - only the actual files that exist
        // Note: Light font is "Karu Light.otf" (with space and .otf extension)
        let karuFonts = [
            ("karu-regular", "ttf"),
            ("karu-bold", "ttf"),
            ("karu-medium", "ttf"),
            ("Karu Light", "otf"),  // Light font has space and .otf extension
            ("karu-extralight", "ttf")
        ]
        
        for (fontName, ext) in karuFonts {
            var registered = false
            
            // Try different path combinations
            let paths = [
                ("Karu Font Family", nil),
                ("Fonts/Karu Font Family", nil),
                ("Fonts", "Karu Font Family"),
                (nil, nil)  // Root level
            ]
            
            for (subdir, subsubdir) in paths {
                if let subdir = subdir {
                    if let subsubdir = subsubdir {
                        if let fontURL = Bundle.module.url(forResource: fontName, withExtension: ext, subdirectory: "\(subdir)/\(subsubdir)") {
                            registered = registerFont(at: fontURL, name: fontName)
                            if registered { break }
                        }
                    } else {
                        if let fontURL = Bundle.module.url(forResource: fontName, withExtension: ext, subdirectory: subdir) {
                            registered = registerFont(at: fontURL, name: fontName)
                            if registered { break }
                        }
                    }
                } else {
                    if let fontURL = Bundle.module.url(forResource: fontName, withExtension: ext) {
                        registered = registerFont(at: fontURL, name: fontName)
                        if registered { break }
                    }
                }
            }
            
            if !registered {
                print("WARNING: Could not find or register font: \(fontName).\(ext)")
            }
        }
        
        // Also try to list all font files in the bundle to debug
        print("\n=== Searching for font files in bundle ===")
        if let fontsPath = Bundle.module.resourcePath {
            let fileManager = FileManager.default
            if let enumerator = fileManager.enumerator(atPath: fontsPath) {
                for case let file as String in enumerator {
                    if file.lowercased().contains("karu") && (file.hasSuffix(".ttf") || file.hasSuffix(".otf")) {
                        print("Found font file: \(file)")
                    }
                }
            }
        }
        print("==========================================\n")
        
        // After registration, list all available fonts
        print("\n=== All Available Fonts ===")
        for family in UIFont.familyNames.sorted() {
            let fonts = UIFont.fontNames(forFamilyName: family)
            if family.lowercased().contains("karu") || fonts.contains(where: { $0.lowercased().contains("karu") }) {
                print("Family: \(family)")
                for font in fonts {
                    print("  - \(font)")
                }
            }
        }
        print("===========================\n")
    }
    
    @discardableResult
    private static func registerFont(at url: URL, name: String) -> Bool {
        print("Attempting to register font: \(name) from \(url.lastPathComponent)")
        
        guard let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("  ERROR: Could not create CGFont from URL")
            return false
        }
        
        // Get the PostScript name before registration
        if let postScriptName = font.postScriptName {
            print("  PostScript name: \(postScriptName)")
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if success {
            print("  SUCCESS: Font registered")
            // Verify it's available
            if let postScriptName = font.postScriptName as String? {
                if UIFont(name: postScriptName, size: 12) != nil {
                    print("  Verified: Font is available as '\(postScriptName)'")
                } else {
                    print("  WARNING: Font registered but not found by name '\(postScriptName)'")
                }
            }
        } else {
            if let error = error?.takeRetainedValue() {
                print("  ERROR: Failed to register font - \(error)")
            } else {
                print("  ERROR: Failed to register font (unknown error)")
            }
        }
        
        return success
    }
}

// MARK: - Font Extension

extension Font {
    /// Creates a font from a token
    /// - Parameter token: The font token to use
    /// - Returns: A configured Font
    public static func token(_ token: FontToken) -> Font {
        switch token {
        // Title fonts (Microgramma D Extended Bold)
        case .titleExtraLarge:
            return microgrammaFont(size: 34)
        case .titleLarge:
            return microgrammaFont(size: 28)
        case .titleMedium:
            return microgrammaFont(size: 22)
        case .titleSmall:
            return microgrammaFont(size: 18)
        case .titleExtraSmall:
            return microgrammaFont(size: 14)
        case .titleTiny:
            return microgrammaFont(size: 12)
        case .title(let size):
            return microgrammaFont(size: size)
        
        // Label fonts (Karu Font Family)
        case .labelExtraLarge:
            return karuFont(size: 20)
        case .labelLarge:
            return karuFont(size: 18)
        case .labelMedium:
            return karuFont(size: 16)
        case .labelSmall:
            return karuFont(size: 14)
        case .labelExtraSmall:
            return karuFont(size: 12)
        case .labelTiny:
            return karuFont(size: 10)
        case .body:
            return karuFont(size: 16)
        case .caption:
            return karuFont(size: 12)
        }
    }
    
    /// Creates a light weight font from a token
    /// Use this instead of .fontWeight(.light) for custom fonts
    /// - Parameter token: The font token to use
    /// - Returns: A configured Font with light weight
    public static func tokenLight(_ token: FontToken) -> Font {
        switch token {
        // Title fonts don't have light variants, return regular
        case .titleExtraLarge, .titleLarge, .titleMedium, .titleSmall, .titleExtraSmall, .titleTiny, .title:
            return .token(token)
        
        // Label fonts (Karu Font Family) - use light weight
        case .labelExtraLarge:
            return karuFont(size: 20, weight: .light)
        case .labelLarge:
            return karuFont(size: 18, weight: .light)
        case .labelMedium:
            return karuFont(size: 16, weight: .light)
        case .labelSmall:
            return karuFont(size: 14, weight: .light)
        case .labelExtraSmall:
            return karuFont(size: 12, weight: .light)
        case .labelTiny:
            return karuFont(size: 10, weight: .light)
        case .body:
            return karuFont(size: 16, weight: .light)
        case .caption:
            return karuFont(size: 12, weight: .light)
        }
    }
    
    /// Creates a title font with a custom size
    /// - Parameter size: The font size in points
    /// - Returns: A configured Font using Microgramma D Extended Bold
    public static func title(size: CGFloat) -> Font {
        return microgrammaFont(size: size)
    }
    
    /// Creates a label font with a custom size
    /// - Parameters:
    ///   - size: The font size in points
    ///   - weight: The font weight (default: .regular)
    /// - Returns: A configured Font using Karu Font Family
    public static func label(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return karuFont(size: size, weight: weight)
    }
    
    /// Helper to create Microgramma font
    /// Tries multiple font name variations
    private static func microgrammaFont(size: CGFloat) -> Font {
        // Try different name variations
        let fontNames = [
            "MicrogrammaD-BoldExte",           // PostScript name
            "Microgramma D Extended Bold",      // Full display name
            "MicrogrammaDExtended-Bold",         // Alternative PostScript
            "Microgramma D Bold Extended"        // Alternative display name
        ]
        
        // Try to find the registered font name
        for fontName in fontNames {
            if let font = UIFont(name: fontName, size: size) {
                return Font(font)
            }
        }
        
        // Fallback to custom font (SwiftUI will handle fallback)
        return .custom("MicrogrammaD-BoldExte", size: size)
    }
    
    /// Helper to create Karu font
    /// Creates fonts in a way that allows SwiftUI's .bold() to find bold variants
    /// and preserves size when bold is applied
    private static func karuFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Map weight to specific font files
        switch weight {
        case .bold, .semibold, .heavy, .black:
            // Bold weight
            let boldNames = ["Karu-Bold", "Karu Bold", "karu-bold"]
            for name in boldNames {
                if let boldFont = UIFont(name: name, size: size) {
                    return Font(boldFont)
                }
            }
        case .medium:
            // Medium weight
            let mediumNames = ["Karu-Medium", "Karu Medium", "karu-medium"]
            for name in mediumNames {
                if let mediumFont = UIFont(name: name, size: size) {
                    return Font(mediumFont)
                }
            }
        case .light:
            // Light weight
            let lightNames = ["Karu-Light", "Karu Light", "karu-light"]
            for name in lightNames {
                if let lightFont = UIFont(name: name, size: size) {
                    return Font(lightFont)
                }
            }
        case .ultraLight, .thin:
            // Extra light weight
            let extralightNames = ["Karu-ExtraLight", "Karu ExtraLight", "karu-extralight", "KaruExtralight"]
            for name in extralightNames {
                if let extralightFont = UIFont(name: name, size: size) {
                    return Font(extralightFont)
                }
            }
            // Fallback to light if extra light not found
            let lightNames = ["Karu-Light", "Karu Light", "karu-light"]
            for name in lightNames {
                if let lightFont = UIFont(name: name, size: size) {
                    return Font(lightFont)
                }
            }
        default:
            // Regular weight
            break
        }
        
        // For regular weight, use Font.custom() which preserves size better
        // This allows .bold() to work while maintaining the size
        let regularNames = ["Karu-Regular", "Karu Regular", "karu-regular"]
        for name in regularNames {
            if UIFont(name: name, size: size) != nil {
                // Use Font.custom() - this preserves size when .bold() is applied
                return Font.custom(name, size: size)
            }
        }
        
        // Fallback
        return Font.custom("Karu-Regular", size: size)
    }
}

// MARK: - View Extension for Bold Support

extension View {
    /// Applies bold using Karu-Bold font with the specified size
    /// Use this instead of .bold() for Karu fonts to preserve size
    /// Example: Text("Hello").font(.token(.labelLarge)).karuBold(size: 18)
    public func karuBold(size: CGFloat) -> some View {
        self.modifier(KaruBoldModifier(size: size))
    }
}

struct KaruBoldModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        // Try to find bold font with the specified size
        let boldNames = ["Karu-Bold", "Karu Bold", "karu-bold"]
        for name in boldNames {
            if let boldFont = UIFont(name: name, size: size) {
                return AnyView(content.font(Font(boldFont)))
            }
        }
        
        // Fallback: use system bold
        return AnyView(content.bold())
    }
}

// MARK: - Color Extension

extension Color {
    /// Creates a color from a token
    /// - Parameter token: The color token to use
    /// - Returns: A Color from the asset catalog
    public static func token(_ token: ColorToken) -> Color {
        let colorName: String
        
        switch token {
        case .black:
            colorName = "black"
        case .blueAccent:
            colorName = "blueAccent"
        case .blueishSurface:
            colorName = "blueishSurface"
        case .blueSecondary:
            colorName = "blueSecondary"
        case .customBlue:
            colorName = "customBlue"
        case .customDarkBlue:
            colorName = "customDarkBlue"
        case .customOrange:
            colorName = "customOrange"
        case .customPurple:
            colorName = "customPurple"
        case .customTeal:
            colorName = "customTeal"
        case .green:
            colorName = "green"
        case .lightBeige:
            colorName = "lightBeige"
        case .lightBlueAccent:
            colorName = "lightBlueAccent"
        case .lightGreen:
            colorName = "lightGreen"
        case .lightPinkAccent:
            colorName = "lightPinkAccent"
        case .lightTeal:
            colorName = "lightTeal"
        case .orangeYellowSurface:
            colorName = "orangeYellowSurface"
        case .peach:
            colorName = "peach"
        case .pinkAccent:
            colorName = "pinkAccent"
        case .purpleAccent:
            colorName = "purpleAccent"
        case .purpleSurface:
            colorName = "purpleSurface"
        case .tealContainer:
            colorName = "tealContainer"
        case .tealSecondary:
            colorName = "tealSecondary"
        case .warning:
            colorName = "warning"
        case .yellowOrangeSecondary:
            colorName = "yellowOrangeSecondary"
        case .pink:
            colorName = "pinkAccent"
        }
        
        return Color(colorName, bundle: .module)
    }
}

