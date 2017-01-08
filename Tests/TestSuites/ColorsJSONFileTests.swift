//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsJSONFileTests: XCTestCase {
  static let colors = [
    ["name": "ArticleBody", "rgba": "339666ff", "red": "33", "blue": "66", "alpha": "ff", "green": "96", "rgb": "339666"],
    ["name": "ArticleFootnote", "rgba": "ff66ccff", "red": "ff", "blue": "cc", "alpha": "ff", "green": "66", "rgb": "ff66cc"],
    ["name": "ArticleTitle", "rgba": "33fe66ff", "red": "33", "blue": "66", "alpha": "ff", "green": "fe", "rgb": "33fe66"],
    ["name": "Cyan-Color", "rgba": "ff66ccff", "red": "ff", "blue": "cc", "alpha": "ff", "green": "66", "rgb": "ff66cc"],
    ["name": "Translucent", "rgba": "ffffffcc", "red": "ff", "blue": "ff", "alpha": "cc", "green": "ff", "rgb": "ffffff"]
  ]
  
  func testEmpty() {
    let parser = ColorsJSONFileParser()

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": [[String: String]]()
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.json"))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": ColorsJSONFileTests.colors
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.json"))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let result = parser.stencilContext(enumName: "XCTColors")
    let expected: [String: Any] = [
      "enumName": "XCTColors",
      "colors": ColorsJSONFileTests.colors
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsJSONFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors-bad-syntax.json"))
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
      try parser.parseFile(at: Fixtures.path(for: "colors-bad-value.json"))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
