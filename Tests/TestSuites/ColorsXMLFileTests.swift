//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
import SwiftGenKit

class ColorsXMLFileTests: XCTestCase {
  func testEmpty() {
    let parser = ColorsXMLFileParser()

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "empty.plist", sub: .colors)
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.xml", sub: .colors))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "defaults.plist", sub: .colors)
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "colors.xml", sub: .colors))
    } catch {
      XCTFail("Exception while parsing file: \(error)")
    }

    let result = parser.stencilContext(enumName: "XCTColors")
    let expected = Fixtures.context(for: "customname.plist", sub: .colors)
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithBadSyntax() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-syntax.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    let parser = ColorsXMLFileParser()
    do {
      try parser.parseFile(at: Fixtures.path(for: "bad-value.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch ColorsParserError.invalidHexColor(string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
