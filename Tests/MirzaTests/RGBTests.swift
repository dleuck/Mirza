//
//  File.swift
//  
//
//  Created by Daniel Leuck on 2023/03/13.
//

import XCTest
import SwiftUI

@testable import Mirza

final class RGBTests: XCTestCase {

    func testMix() throws {
        XCTAssertEqual(RGB.red.mix(RGB.white, percent: 0.2), RGB(100, 20, 20))
        XCTAssertEqual(RGB.red.mix(RGB.red), RGB.red)
        XCTAssertEqual(RGB.blue.mix(RGB.blue, percent: 0.5), RGB.blue)
    }
    
    func testFromHexString() throws {
        XCTAssertEqual(RGB(hex:"FFFFFF"), RGB.white)
        XCTAssertEqual(RGB(hex:"FFFF00"), RGB(100,100,0))
        XCTAssertEqual(RGB(hex:"00FF01").blue.rounded(places: 1), 0.4)
    }
}

