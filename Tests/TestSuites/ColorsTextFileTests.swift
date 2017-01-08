//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsTextFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsTextFileParser()

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "colors-empty.plist")
    
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
    let expected = Fixtures.context(for: "colors-list-defaults.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt"))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "colors-text-defaults.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsTextFileParser()
    try! parser.parseFile(at: Fixtures.path(for: "colors.txt"))

    let result = parser.stencilContext(enumName: "XCTColors")
    let expected = Fixtures.context(for: "colors-text-customname.plist")
    
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
