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
    XCTDiffContexts(result, expected: "empty.plist", sub: .strings)
  }

  func testEntriesWithDefaults() {
    let parser = StringsFileParser()
    parser.addEntry(StringsFileParser.Entry(key: "Title",
                                            translation: "My awesome title"))
    parser.addEntry(StringsFileParser.Entry(key: "Greetings",
                                            translation: "Hello, my name is %@ and I'm %d",
                                            types: .object, .int))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "entries.plist", sub: .strings)
  }

  func testFileWithDefaults() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .strings)
  }

  func testMultiline() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiline.plist", sub: .strings)
  }

  func testUTF8FileWithDefaults() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "LocUTF8.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "utf8.plist", sub: .strings)
  }

  func testFileWithCustomName() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext(enumName: "XCTLoc")
    XCTDiffContexts(result, expected: "customname.plist", sub: .strings)
  }

  func testFileWithStructuredOnly() throws {
    let parser = StringsFileParser()
    try parser.parseFile(at: Fixtures.path(for: "LocStructuredOnly.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "structuredonly.plist", sub: .strings)
  }
}
