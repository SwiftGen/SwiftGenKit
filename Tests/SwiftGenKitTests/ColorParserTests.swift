//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
@testable import SwiftGenKit

class ColorParserTests: XCTestCase {

  // MARK: String parsing

  func testStringNoPrefix() throws {
    let color = try parse(hex: "FFFFFF")
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithHash() throws {
    let color = try parse(hex: "#FFFFFF")
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWith0x() throws {
    let color = try parse(hex: "0xFFFFFF")
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithAlpha() throws {
    let color = try parse(hex: "FFFFFFCC")
    XCTAssertEqual(color, 0xFFFFFFCC)
  }

  // MARK: Hex Value

  func testHexValues() {
    let colors: [NSColor: UInt32] = [
      NSColor(red: 0, green: 0, blue: 0, alpha: 0): 0x00000000,
      NSColor(red: 1, green: 1, blue: 1, alpha: 1): 0xFFFFFFFF,
      NSColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1): 0xF8F8F8FF,
      NSColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1): 0xF7F7F7FF
    ]

    for (color, value) in colors {
      XCTAssertEqual(color.hexValue, value)
    }
  }
}
