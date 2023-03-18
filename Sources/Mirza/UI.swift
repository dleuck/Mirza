//
//  UI.swift
//  
//
//  Created by Daniel Leuck on 2023/03/12.
//

import SwiftUI

public func rgb(_ r: Double, _ g: Double, _ b: Double, alpha: Double = 100) -> Color {
    return Color(red: r / 100.0, green: g / 100.0, blue: b / 100.0, opacity: alpha / 100.0)
}

public func gray(_ gray: Double, alpha: Double = 100) -> Color {
    return Color(red: gray / 100.0, green: gray / 100.0, blue: gray / 100.0, opacity: alpha / 100.0)
}
