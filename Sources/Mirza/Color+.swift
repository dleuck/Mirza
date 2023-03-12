//
//  Color.swift
//  Mirza
//
//  Created by Daniel Leuck on 2023/03/11.
//

import Foundation

import SwiftUI
import KiCore

public extension Color {
    var components: [Double] {
        let comps = cgColor!.components!
        var dcomps = [Double]()
        for c in comps {
            let dvalue: Double = c
            dcomps.append((dvalue).rounded(places: 2) * 100.0)
        }
        
        return dcomps
    }
}

public func color(_ r:Double, _ g:Double, _ b:Double, alpha:Double = 100) -> Color {
    return Color(red: r / 100.0, green: g / 100.0, blue: b / 100.0, opacity: alpha / 100.0)
}
