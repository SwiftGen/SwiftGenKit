//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
@testable import SwiftGenKit

class ColorsXMLFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = try ColorsFileParser()
    parser.colors = try ColorsXMLFileParser().parseFile(at: Fixtures.path(for: "colors.xml", sub: .colors))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .colors)
  }

  func testFileWithBadSyntax() {
    do {
      _ = try ColorsXMLFileParser().parseFile(at: Fixtures.path(for: "bad-syntax.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    do {
      _ = try ColorsXMLFileParser().parseFile(at: Fixtures.path(for: "bad-value.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
