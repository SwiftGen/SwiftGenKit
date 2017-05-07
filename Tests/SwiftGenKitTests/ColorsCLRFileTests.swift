//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsCLRFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsCLRFileParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .colors)
  }

  func testFileWithDefaults() throws {
    let parser = ColorsCLRFileParser()
    try parser.parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .colors)
  }

  func testFileWithCustomName() throws {
    let parser = ColorsCLRFileParser()
    try parser.parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))

    let result = parser.stencilContext(enumName: "XCTColors")
    XCTDiffContexts(result, expected: "customname.plist", sub: .colors)
  }

  func testFileWithBadFile() {
    let parser = ColorsCLRFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad.clr", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad file")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
