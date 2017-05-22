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
    XCTDiffContexts(result, expected: "empty.plist", sub: .colors)
  }

  func testListWithDefaults() throws {
    let parser = ColorsTextFileParser()

    try parser.addColor(named: "Text&Body Color", value: "0x999999")
    try parser.addColor(named: "ArticleTitle", value: "#996600")
    try parser.addColor(named: "ArticleBackground", value: "#ffcc0099")

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "entries.plist", sub: .colors)
  }

  func testFileWithDefaults() throws {
    let parser = ColorsTextFileParser()
    try parser.parseFile(at: Fixtures.path(for: "colors.txt", sub: .colors))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "text-defaults.plist", sub: .colors)
  }

  func testFileWithCustomName() throws {
    let parser = ColorsTextFileParser()
    try parser.parseFile(at: Fixtures.path(for: "colors.txt", sub: .colors))

    let result = parser.stencilContext(enumName: "XCTColors")
    XCTDiffContexts(result, expected: "text-customname.plist", sub: .colors)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsTextFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-syntax.txt", sub: .colors))
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
      try parser.parseFile(at: Fixtures.path(for: "bad-value.txt", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "thisIsn'tAColor", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

}
