//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import SwiftGenKit

class StringParserTests: XCTestCase {
  func testParseStringPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%@")
    XCTAssertEqual(placeholders, [.object])
  }

  func testParseFloatPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%f")
    XCTAssertEqual(placeholders, [.float])
  }

  func testParseDoublePlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%g-%e")
    XCTAssertEqual(placeholders, [.float, .float])
  }

  func testParseFloatWithPrecisionPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.float, .float, .float, .float])
  }

  func testParseIntPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.int, .int, .int, .int, .int])
  }

  func testParseCCharAndStringPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%c-%s")
    XCTAssertEqual(placeholders, [.char, .cString])
  }

  func testParsePositionalPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.char, .int, .object, .float])
  }

  func testParseComplexFormatPlaceholders() {
    let format = "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%"
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: format)
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
    XCTAssertEqual(placeholders, [.unknown, .int, .object, .float, .char])
  }

  func testParseEvenEscapePercentSign() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%%foo")
    // Must NOT map to [.float]
    XCTAssertEqual(placeholders, [])
  }

  func testParseOddEscapePercentSign() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%%%foo")
    // Should map to [.float]
    XCTAssertEqual(placeholders, [.float])
  }
}
