//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsTextFileTests: XCTestCase {
  static let colors = [
    ["name": "ArticleBody", "rgba": "339666ff", "red": "33", "blue": "66", "alpha": "ff", "green": "96", "rgb": "339666"],
    ["name": "ArticleFootnote", "rgba": "ff66ccff", "red": "ff", "blue": "cc", "alpha": "ff", "green": "66", "rgb": "ff66cc"],
    ["name": "ArticleTitle", "rgba": "33fe66ff", "red": "33", "blue": "66", "alpha": "ff", "green": "fe", "rgb": "33fe66"],
    ["name": "Cyan-Color", "rgba": "ff66ccff", "red": "ff", "blue": "cc", "alpha": "ff", "green": "66", "rgb": "ff66cc"],
    ["name": "NamedValue", "rgba": "ffffffcc", "red": "ff", "blue": "ff", "alpha": "cc", "green": "ff", "rgb": "ffffff"],
    ["name": "NestedNamedValue", "rgba": "ffffffcc", "red": "ff", "blue": "ff", "alpha": "cc", "green": "ff", "rgb": "ffffff"],
    ["name": "Translucent", "rgba": "ffffffcc", "red": "ff", "blue": "ff", "alpha": "cc", "green": "ff", "rgb": "ffffff"]
  ]

  func testEmpty() {
    let parser = ColorsTextFileParser()

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": [[String: String]]()
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testListWithDefaults() {
    let parser = ColorsTextFileParser()
    do {
      try parser.addColor(named: "Text&Body Color", value: "0x999999")
      try parser.addColor(named: "ArticleTitle", value: "#996600")
      try parser.addColor(named: "ArticleBackground", value: "#ffcc0099")
    } catch {
      XCTFail("Failed with unexpected error \(error)")
    }

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": [
        ["name": "ArticleBackground", "rgba": "ffcc0099", "red": "ff", "blue": "00", "alpha": "99", "green": "cc", "rgb": "ffcc00"],
        ["name": "ArticleTitle", "rgba": "996600ff", "red": "99", "blue": "00", "alpha": "ff", "green": "66", "rgb": "996600"],
        ["name": "Text&Body Color", "rgba": "999999ff", "red": "99", "blue": "99", "alpha": "ff", "green": "99", "rgb": "999999"]
      ]
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt"))

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "ColorName",
      "colors": ColorsTextFileTests.colors
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt"))

    let result = parser.stencilContext(enumName: "XCTColors")
    let expected: [String: Any] = [
      "enumName": "XCTColors",
      "colors": ColorsTextFileTests.colors
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsTextFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors-bad-syntax.txt"))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    let parser = ColorsTextFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors-bad-value.txt"))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "thisIsn'tAColor", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

}
