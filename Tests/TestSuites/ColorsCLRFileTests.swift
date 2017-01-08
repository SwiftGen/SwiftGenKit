//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsCLRFileTests: XCTestCase {
  static let colors = [
    ["name": "ArticleBody", "rgba": "339666ff", "red": "33", "blue": "66", "alpha": "ff", "green": "96", "rgb": "339666"],
    ["name": "ArticleFootnote", "rgba": "ff66ccff", "red": "ff", "blue": "cc", "alpha": "ff", "green": "66", "rgb": "ff66cc"],
    ["name": "ArticleTitle", "rgba": "33fe66ff", "red": "33", "blue": "66", "alpha": "ff", "green": "fe", "rgb": "33fe66"],
    ["name": "Cyan-Color", "rgba": "ff66ccff", "red": "ff", "blue": "cc", "alpha": "ff", "green": "66", "rgb": "ff66cc"],
    ["name": "Translucent", "rgba": "ffffffcc", "red": "ff", "blue": "ff", "alpha": "cc", "green": "ff", "rgb": "ffffff"]
  ]

  func testEmpty() {
    let parser = ColorsCLRFileParser()

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": [[String: String]]()
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsCLRFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.clr"))

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": ColorsCLRFileTests.colors
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsCLRFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.clr"))

    let result = parser.stencilContext(enumName: "XCTColors")
    let expected: [String: Any] = [
      "enumName": "XCTColors",
      "colors": ColorsCLRFileTests.colors
    ]
    
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
