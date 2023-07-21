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
                dcomps.append(dvalue * 1.0)
                // dcomps.append((dvalue).rounded(places: 2) * 100.0)
            }
            
            return dcomps
        }
    }
    
    init(h: Double, s: Double, l: Double, alpha: Double) {
        precondition(0...1 ~= h &&
                     0...1 ~= s &&
                     0...1 ~= l &&
                     0...1 ~= alpha, "HSL component out of range 0 - 1")
        
        //From HSL TO HSB ---------
        var newSaturation: Double = 0.0
        
        let b = l + s * min(l, 1-l)
        
        if b == 0 { newSaturation = 0.0 }
        else {
            newSaturation = 2 * (1 - l / b)
        }
        //---------
        
        self.init(hue: h, saturation: newSaturation, brightness: b, opacity: alpha)
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
