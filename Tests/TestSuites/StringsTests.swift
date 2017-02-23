//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import SwiftGenKit

/**
 * Important: In order for the "*.strings" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.strings" using PBXCp »
 */

class StringsTests: XCTestCase {

  func testEmpty() {
    let parser = StringsFileParser()

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "empty.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  func testEntriesWithDefaults() {
    let parser = StringsFileParser()
    parser.addEntry(StringsFileParser.Entry(key: "Title",
                                            translation: "My awesome title"))
    parser.addEntry(StringsFileParser.Entry(key: "Greetings",
                                            translation: "Hello, my name is %@ and I'm %d",
                                            types: .Object, .Int))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "entries.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "defaults.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  func testMultiline() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "multiline.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  func testUTF8FileWithDefaults() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "LocUTF8.strings", sub: .strings))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "utf8.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext(enumName: "XCTLoc")
    let expected = Fixtures.context(for: "customname.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  func testFileWithStructuredOnly() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "LocStructuredOnly.strings", sub: .strings))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "structuredonly.plist", sub: .strings)

    XCTDiffContexts(result, expected)
  }

  ////////////////////////////////////////////////////////////////////////

  func testParseStringPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%@")
    XCTAssertEqual(placeholders, [.Object])
  }

  func testParseFloatPlaceholder() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%f")
    XCTAssertEqual(placeholders, [.Float])
  }

  func testParseDoublePlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%g-%e")
    XCTAssertEqual(placeholders, [.Float, .Float])
  }

  func testParseFloatWithPrecisionPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.Float, .Float, .Float, .Float])
  }

  func testParseIntPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.Int, .Int, .Int, .Int, .Int])
  }

  func testParseCCharAndStringPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%c-%s")
    XCTAssertEqual(placeholders, [.Char, .CString])
  }

  func testParsePositionalPlaceholders() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.Char, .Int, .Object, .Float])
  }

  func testParseComplexFormatPlaceholders() {
    let format = "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%"
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: format)
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
    XCTAssertEqual(placeholders, [.Unknown, .Int, .Object, .Float, .Char])
  }

  func testParseEscapePercentSign() {
    let placeholders = StringsFileParser.PlaceholderType.placeholders(fromFormat: "%%foo")
    // Must NOT map to [.Float]
    XCTAssertEqual(placeholders, [])
  }

}
