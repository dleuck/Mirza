//
//  UI.swift
//  
//
//  Created by Daniel Leuck on 2023/03/12.
//

import SwiftUI

public func rgb(_ r: Double, _ g: Double, _ b: Double, alpha: Double = 100) -> Color {
    return Color(red: r / 100, green: g / 100, blue: b / 100, opacity: alpha / 100)
}

public func gray(_ gray: Double, alpha: Double = 100) -> Color {
    return Color(red: gray / 100, green: gray / 100, blue: gray / 100, opacity: alpha / 100)
}
