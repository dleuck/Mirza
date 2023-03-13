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
        XCTAssertEqual(RGB.red.mix(RGB.red), RGB.blue)
        XCTAssertEqual(RGB.blue.mix(RGB.blue, percent: 0.5), RGB.blue)
    }
}

