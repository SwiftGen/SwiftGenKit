//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import PathKit
import XCTest
@testable import SwiftGenKit

final class TestFileParser1: ColorsFileTypeParser {
  static let extensions = ["test1"]
  func parseFile(at path: Path) throws -> [String: UInt32] {
    return ["test1": 1]
  }
}

final class TestFileParser2: ColorsFileTypeParser {
  static let extensions = ["test2"]
  func parseFile(at path: Path) throws -> [String: UInt32] {
    return ["test2": 1]
  }
}

final class TestFileParser3: ColorsFileTypeParser {
  static let extensions = ["test1"]
  func parseFile(at path: Path) throws -> [String: UInt32] {
    return [:]
  }
}

class ColorParserTests: XCTestCase {
  func testEmpty() throws {
    let parser = try ColorsFileParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .colors)
  }

  // MARK: - Dispatch

  func testDispatchKnowExtension() throws {
    let parser = try ColorsFileParser()
    try parser.register(parser: TestFileParser1.self)
    try parser.register(parser: TestFileParser2.self)

    try parser.parseFile(at: "someFile.test1")
    XCTAssertEqual(parser.colors["test1"], 1)
    XCTAssertNil(parser.colors["test2"])
  }

  func testDispatchUnknownExtension() throws {
    let parser = try ColorsFileParser()
    try parser.register(parser: TestFileParser1.self)
    try parser.register(parser: TestFileParser2.self)

    do {
      try parser.parseFile(at: "someFile.unknown")
      XCTFail("Code did succeed while it was expected to fail for unknown extension")
    } catch ColorsParserError.unsupportedFileType {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testDuplicateExtensionError() throws {
    let parser = try ColorsFileParser()

    do {
      try parser.register(parser: TestFileParser1.self)
      try parser.register(parser: TestFileParser3.self)
      XCTFail("Code did succeed while it was expected to fail for duplicate extension")
    } catch ColorsParserError.duplicateExtensionParser {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  // MARK: - String parsing

  func testStringNoPrefix() throws {
    let color = try parse(hex: "FFFFFF")
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithHash() throws {
    let color = try parse(hex: "#FFFFFF")
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWith0x() throws {
    let color = try parse(hex: "0xFFFFFF")
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithAlpha() throws {
    let color = try parse(hex: "FFFFFFCC")
    XCTAssertEqual(color, 0xFFFFFFCC)
  }

  // MARK: - Hex Value

  func testHexValues() {
    let colors: [NSColor: UInt32] = [
      NSColor(red: 0, green: 0, blue: 0, alpha: 0): 0x00000000,
      NSColor(red: 1, green: 1, blue: 1, alpha: 1): 0xFFFFFFFF,
      NSColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1): 0xF8F8F8FF,
      NSColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1): 0xF7F7F7FF
    ]

    for (color, value) in colors {
      XCTAssertEqual(color.hexValue, value)
    }
  }
}
