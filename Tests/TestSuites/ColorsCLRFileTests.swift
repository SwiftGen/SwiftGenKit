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
    let expected = Fixtures.context(for: "colors-empty.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsCLRFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.clr"))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "colors-clr-defaults.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsCLRFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.clr"))

    let result = parser.stencilContext(enumName: "XCTColors")
    let expected = Fixtures.context(for: "colors-clr-customname.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithBadFile() {
    let parser = ColorsCLRFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors-bad.clr"))
      XCTFail("Code did parse file successfully while it was expected to fail for bad file")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
