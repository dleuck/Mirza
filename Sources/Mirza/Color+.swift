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

    /**
     * Some SwiftUI colors don't provide color components. In these cased the components array
     * will be empty.
     */
    var components: [Double] {
        var dcomps = [Double]()
        if cgColor == nil || cgColor!.components == nil {
            return dcomps
        } else {
            let comps = cgColor!.components!
            
            for c in comps {
                let dvalue: Double = c
                dcomps.append(dvalue * 100.0)
                // dcomps.append((dvalue).rounded(places: 2) * 100.0)
            }
            
            return dcomps
        }
    }
}

public func color(_ r:Double, _ g:Double, _ b:Double, alpha:Double = 100) -> Color {
    return Color(red: r / 100.0, green: g / 100.0, blue: b / 100.0, opacity: alpha / 100.0)
}

public func rgb(_ r: Double, _ g: Double, _ b: Double, alpha: Double = 100) -> Color {
    return Color(red: r / 100.0, green: g / 100.0, blue: b / 100.0, opacity: alpha / 100.0)
}

public func gray(_ gray: Double, alpha: Double = 100) -> Color {
    return Color(red: gray / 100.0, green: gray / 100.0, blue: gray / 100.0, opacity: alpha / 100.0)
}
