//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT License
//

import XCTest
@testable import SwiftGenKit

class UtilsTests: XCTestCase {
  func testFormatSpecialCharacters() {
    let specialCharacters = "!@#$%~`^&*()_+-={}|[]\\;\':\"<>?,./"
    let expected = specialCharacters.characters.map { _ in "_" }.joined()
    XCTAssertEqual(expected, format(specialCharacters))
  }
  func testFormatNumber() {
    let specialCharacters = "1234"
    XCTAssertEqual("_234", format(specialCharacters))
  }
  func testFormatString() {
    let specialCharacters = "aaaa~~bbbb"
    XCTAssertEqual("aaaa__bbbb", format(specialCharacters))
  }
}
