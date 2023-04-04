//
//  Palette.swift
//
//
//  Created by Daniel Leuck on 2023/02/23.
//

import SwiftUI

public enum ColorScheme {
    case triadic
    case tetradic
}

/**
 * A palette of colors (color scheme)
 */
public struct Palette: Codable, CustomStringConvertible, Identifiable, Hashable, Equatable {
    
    public var id: String { name }
    
    // TODO: Add standard named variants - pastel, veryLight, light, base, dark, varyDark
    
    public let name: String
    public let primary: RGB
    public let secondary: RGB
    public let tertiary: RGB
    public let quaternary: RGB
    public let danger: RGB

    public static let fun = Palette(
        name: "fun", webRGB(102, 71, 216), webRGB(43, 139, 49), webRGB(208, 178, 26)
    )
    
    public static let nature = Palette(
        name: "default", webRGB(67, 137, 194), webRGB(149, 200, 46), webRGB(218, 175, 63)
    )
    
    public static let trafficLight = Palette(
        name: "traffic light", webRGB(50, 127, 97), webRGB(229, 161, 10), webRGB(216, 58, 50)
    )
    
    public static let rainbow = Palette(
        name: "rainbow", webRGB(163, 130, 212), webRGB(137, 195, 233), webRGB(250, 234, 144)
    )
    
    public static let social = Palette(
        name: "social", webRGB(12, 198, 171), webRGB(84, 33, 244), webRGB(203, 148, 8),
            webRGB(214, 101, 8)
    )
    
    public static let nouveau = Palette(
        name: "nouveau", webRGB(57, 174, 160), webRGB(111, 62, 193), webRGB(217, 108, 20),
            webRGB(125, 168, 53)
    )

    public init(name: String, _ primary: RGB, _ secondary: RGB, _ tertiary: RGB,
                _ quaternary: RGB? = nil, danger: RGB = RGB(80, 10, 10)) {
        
        self.name = name
        
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.quaternary = (quaternary == nil) ? tertiary : quaternary!
        self.danger = danger
    }
    
    /// Get all built-in palettes
    public static func getPalettes() -> [Palette] {
        return [fun, nature, trafficLight, rainbow, social, nouveau]
    }

    /// Get all the scheme type, currently either triadic or tetradic
    public func getSchemeType() -> ColorScheme {
        return tertiary == quaternary ? .triadic : .tetradic
    }
    
    public var rgbs: [RGB] {
        return getSchemeType() == .triadic
            ? [primary, secondary, tertiary, danger]
            : [primary, secondary, tertiary, quaternary, danger]
    }
    
    public var colors: [Color] {
        return getSchemeType() == .triadic
        ? [primary.color, secondary.color, tertiary.color, danger.color]
        : [primary.color, secondary.color, tertiary.color, quaternary.color, danger.color]
    }
    
    public var description: String {
        return getSchemeType() == .triadic
            ? "\(name) - primary:\(primary), secondary:\(secondary), tertiary:\(tertiary), danger:\(danger)"
            : "\(name) - primary:\(primary), secondary:\(secondary), tertiary:\(tertiary) " +
              "quaternary:\(quaternary), danger:\(danger)"
    }
}

