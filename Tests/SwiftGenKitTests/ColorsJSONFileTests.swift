//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsJSONFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsJSONFileParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .colors)
  }

  func testFileWithDefaults() throws {
    let parser = ColorsJSONFileParser()
    try parser.parseFile(at: Fixtures.path(for: "colors.json", sub: .colors))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .colors)
  }

  func testFileWithCustomName() throws {
    let parser = ColorsJSONFileParser()
    try parser.parseFile(at: Fixtures.path(for: "colors.json", sub: .colors))

    let result = parser.stencilContext(enumName: "XCTColors")
    XCTDiffContexts(result, expected: "customname.plist", sub: .colors)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-syntax.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-value.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
