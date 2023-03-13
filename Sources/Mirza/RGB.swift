//
//  RGB.swift
//
//
//  Created by Daniel Leuck on 2022/02/14.
//

import SwiftUI
import KiCore

/**
 * A drop in replacement for Color that uses a more intuative 0-100 RGBA color component system.
 * This makes it much easier to create color variants, schemes, etc. RGBs can be used in View
 * modifiers such as foregroundColor and background.
 */
public struct RGB: Hashable, Codable, Equatable, CustomStringConvertible {

    // TODO: Support creation and access to HSB color components
    
    public static let range = 0.0...100.0
    public static let percentRange = 0.0...1.0
    public static let modRange = -100.0...100.0
    
    public static let clear = RGB(100, 100, 100, alpha: 0)
    public static let white = RGB(100, 100, 100)
    public static let black = RGB(0, 0, 0)
    
    public static let red = RGB(100, 0, 0)
    public static let green = RGB(0, 100, 0)
    public static let blue = RGB(0, 0, 100)
    
    public static let yellow = RGB(100, 100, 0)
    public static let orange = RGB(100, 50, 0)
    public static let purple = RGB(50, 0, 50)
    
    public static let aqua = RGB(0, 50, 50)
    
    public let red: Double
    public let green: Double
    public let blue: Double
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
    
    /*
    public init(h: Double = 0, s: Double = 0, b: Double = 0, alpha: Double = 100,
                name: String = "") {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.name = name
    }
    */
    
    public init(gray: Double = 50) {
        self.init(gray, gray, gray)
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
     * 0 to 1.0 for lightening, 0 to -1.- for darkening
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
    
    public var id: Int { description.hashValue }
    
    // standard variations
    
    public var pastel: RGB { return lightness(0.92) }
    public var lightest: RGB { return lightness(0.75) }
    public var lighter: RGB { return lightness(0.5) }
    public var light: RGB { return lightness(0.25) }
    
    public var darkest: RGB { return lightness(-0.75) }
    public var darker: RGB { return lightness(-0.5) }
    public var dark: RGB { return lightness(-0.25) }
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

