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

public struct Palette: Codable, CustomStringConvertible {
    
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
        name: "social", webRGB(12, 198, 171), webRGB(84, 33, 244), webRGB(206, 158, 5)
    )
    
    public static let nouveau = Palette(
        name: "social", webRGB(57, 174, 160), webRGB(111, 62, 193), webRGB(217, 108, 20),
            webRGB(125, 168, 53)
    )

    public init(name: String, _ primary: RGB, _ secondary: RGB, _ tertiary: RGB,
                _ quaternary: RGB? = nil, danger: RGB = webRGB(193, 62, 80)) {
        
        self.name = name
        
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.quaternary = (quaternary == nil) ? tertiary : quaternary!
        self.danger = danger
    }
    
    public static func getPalettes() -> [Palette] {
        return [fun, nature, trafficLight, rainbow, social, nouveau]
    }

    public func getScheme() -> ColorScheme {
        return tertiary == quaternary ? .triadic : .tetradic
    }
    
    public var rgbs: [RGB] {
        return getScheme() == .triadic
            ? [primary, secondary, tertiary]
            : [primary, secondary, tertiary, quaternary]
    }
    
    public var colors: [Color] {
        return getScheme() == .triadic
            ? [primary.color, secondary.color, tertiary.color]
            : [primary.color, secondary.color, tertiary.color, quaternary.color]
    }
    
    public var description: String {
        return getScheme() == .triadic
            ? "\(name) - primary:\(primary), secondary:\(secondary), tertiary:\(tertiary)"
            : "\(name) - primary:\(primary), secondary:\(secondary), tertiary:\(tertiary) " +
              "quaternary:\(quaternary)"
    }
}

