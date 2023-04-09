//
//  RGB.swift
//
//
//  Created by Daniel Leuck on 2022/02/14.
//

import SwiftUI
import KiCore

/**
 * `RGB` is a replacement for `Color` that uses a more intuative 0 - 100 RGBA color component
 * system. Because the color components are `Double`s, they can represent the same number of colors
 * as the `Color` class.
 *
 * This makes it much easier to create color variants, schemes, etc. `RGB`s can be used in `View`
 * modifiers such as `foregroundColor`, `background` and `tint`. You can use them to generate an
 * array of lighter and darker variants and group them in `Palettes` (color schemes).
 */
public struct RGB: Hashable, Codable, Equatable, CustomStringConvertible {

    // TODO: Support creation and access to HSB color components
    
    internal static let range = 0.0...100.0, percentRange = 0.0...1.0, modRange = -100.0...100.0
    
    public static let clear = RGB(100, 100, 100, alpha: 0), white = RGB(100, 100, 100),
                      black = RGB(0, 0, 0)
    
    public static let red = RGB(100, 0, 0), green = RGB(0, 100, 0), blue = RGB(0, 0, 100)
    
    public static let yellow = RGB(100, 100, 0), orange = RGB(100, 50, 0), purple = RGB(50, 0, 50)
    
    public static let aqua = RGB(0, 50, 50)
    
    public let red, green, blue: Double
    public let alpha: Double
    
    /* TODO
    public var hue: Double { }
    public var saturation: Double { }
    public var brightness: Double { }
    public var lightness: Double { } // maybe
     
    public var hex
    */
     
    public let name: String
    
    public init(_ red: Double = 0, _ green: Double = 0, _ blue: Double = 0, alpha: Double = 100,
                name: String = "") {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.name = name
    }
    
    public init(gray: Double = 50, alpha: Double = 100) {
        self.init(gray, gray, gray)
    }
    
    /// Creates a color from a 6-digit hexadecimal color code.
    public init(hexadecimal6: Int) {
        let red = Double((hexadecimal6 & 0xFF0000) >> 16) / 2.55
        let green = Double((hexadecimal6 & 0x00FF00) >> 8) / 2.55
        let blue = Double(hexadecimal6 & 0x0000FF) / 2.55
        
        self.init(red, green, blue)
    }
    
    public init(_ rgb: RGB, alpha: Double = 100) {
        self.init(rgb.red, rgb.green, rgb.blue, alpha: alpha)
    }
    
    /// Create an RGB from a hex string, with or without alpha
    ///
    /// - Parameter hexadecimal: A hexadecimal representation of the color.
    /// - Returns: `RGB` from a hex string or `nil` if the code is malformed.
    public init!(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }
        
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }
        
        if string.count > 8 {
            string = String(string.prefix(8))
        }
        
        let scanner = Scanner(string: string)
        
        var color: UInt64 = 0
        
        scanner.scanHexInt64(&color)
        
        if string.count == 2 {
            let mask = 0xFF
            
            let g = Int(color) & mask
            
            let gray = Double(g) / 2.55
            
            self.init(gray)
        } else if string.count == 4 {
            let mask = 0x00FF
            
            let g = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let gray = Double(g) / 2.55
            let alpha = Double(a) / 2.55
            
            self.init(gray, alpha: alpha)
        } else if string.count == 6 {
            let mask = 0x0000FF
            
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red = Double(r) / 2.55
            let green = Double(g) / 2.55
            let blue = Double(b) / 2.55
            
            self.init(red, green, blue, alpha: 100)
        } else if string.count == 8 {
            let mask = 0x000000FF
            
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let red = Double(r) / 2.55
            let green = Double(g) / 2.55
            let blue = Double(b) / 2.55
            let alpha = Double(a) / 2.55
            
            self.init(red, green, blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
    public func brightness(_ mod: Double) -> RGB {
        RGB(
            (red * mod).clamp(RGB.range),
            (green * mod).clamp(RGB.range),
            (blue * mod).clamp(RGB.range),
            alpha: alpha
        )
    }
    
    /**
     * 0 to 1.0 for lightening, -1 to 0 for darkening
     */
    public func lightness(_ mod: Double) -> RGB {
        let modifier = mod.clamp(RGB.modRange)
        
        if modifier == 0 {
            return self
        }
        
        return mix(modifier > 0 ? RGB.white : RGB.black, percent: abs(modifier))
    }
    
    // TODO - Move to one param that is calculated for brightness and lightness
    public func smartLight(modBrightness: Double, modLightness: Double, percent: Double = 0.85)
        -> RGB {
            
        let brightColor = brightness(modBrightness)
        let lightnessColor = lightness(modLightness)
        return brightColor.mix(lightnessColor, percent: percent)
    }

    /**
     * Blend in a specified percent (0.0 - 1.0) of the other RGB.
     */
    public func mix(_ other: RGB, percent: Double = 0.5) -> RGB {
        return RGB(
            between(red, other.red, percent: percent),
            between(green, other.green, percent: percent),
            between(blue, other.blue, percent: percent),
            alpha: between(alpha, other.alpha, percent: percent)
        )
    }
    
    public var color: Color { Color(red: red / 100.0, green: green / 100.0, blue: blue / 100.0,
                                    opacity: alpha / 100.0) }
    
    public var description: String {
        let colorSpec = "r:\(red), g:\(green), b:\(blue)\(alpha == 1 ? "" : ", alpha:\(alpha)")"
        return (name.isEmpty) ? colorSpec : "\(name) \(colorSpec)"
    }
    
    public func getRGBVariants() -> [RGB] {
        [pastel, lightest, lighter, light, self, dark, darker, darkest]
    }
    
    public func getColorVariants() -> [Color] {
        [pastel.color, lightest.color, lighter.color, light.color, color, dark.color,
         darker.color, darkest.color]
    }
    
    // TODO: Implement
    // public func getHexString() { }
    
    public var id: Int { description.hashValue }

    // standard variations
    
    public var pastel: RGB { return lightness(0.9) }
    public var lightest: RGB { return lightness(0.75) }
    public var lighter: RGB { return lightness(0.5) }
    public var light: RGB { return lightness(0.25) }
    
    public var darker: RGB { return lightness(-0.5) }
    public var dark: RGB { return lightness(-0.25) }
    public var darkest: RGB { return lightness(-0.75) }
    
    public static func random() -> RGB {
        let red = Double.random(in: 0.0...100.0)
        let green = Double.random(in: 0.0...100.0)
        let blue = Double.random(in: 0.0...100.0)
        return RGB(red, green, blue)
    }
}

/**
 * Transform a web color (0-255 for color components) to an RGB (0.0-1.0).
 */
public func webRGB(_ red: Double = 0, _ green: Double = 0, _ blue: Double = 0,
                          alpha: Double = 255) -> RGB {

    return RGB(red / 2.55, green / 2.55, blue / 2.55, alpha: alpha / 2.55)
}


// ---- RGB modifiers for common color settings

public struct ForegroundRGB: ViewModifier {
    var rgb: RGB
    public func body(content: Content) -> some View { content.foregroundColor(rgb.color) }
}

public extension View {
    func foregroundColor(_ rgb: RGB) -> some View { modifier(ForegroundRGB(rgb: rgb)) }
}

public struct BackgroundRGB: ViewModifier {
    var rgb: RGB
    public func body(content: Content) -> some View { content.background(rgb.color) }
}

extension View {
    public func background(_ rgb: RGB) -> some View { modifier(BackgroundRGB(rgb: rgb)) }
}

public struct TintRGB: ViewModifier {
    var rgb: RGB
    public func body(content: Content) -> some View { content.tint(rgb.color) }
}

extension View {
    public func tint(_ rgb: RGB) -> some View { modifier(TintRGB(rgb: rgb)) }
}

public struct AccentRGB: ViewModifier {
    var rgb: RGB
    public func body(content: Content) -> some View { content.accentColor(rgb.color) }
}

extension View {
    public func accentColor(_ rgb: RGB) -> some View { modifier(AccentRGB(rgb: rgb)) }
}

