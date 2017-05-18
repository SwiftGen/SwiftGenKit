//
//  PlistTests.swift
//  SwiftGenKit
//
//  Created by Toshihiro Suzuki on 4/12/17.
//  Copyright © 2017 SwiftGen. All rights reserved.
//

import XCTest
import SwiftGenKit
import PathKit

class PlistTests: XCTestCase {
  func testEmpty() {
    let parser = PlistParser()

    let result = parser.stencilContext()

    XCTDiffContexts(result, expected: "empty.plist", sub: .plist)
  }
  func testFileWithDefaults() {
    let parser = PlistParser()
    parser.parse(at: Fixtures.path(for: "default.plist", sub: .plist))
    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "default.plist", sub: .plist)
  }
  func testFileWithVariousTypeContents() {
    let parser = PlistParser()
    parser.parse(at: Fixtures.path(for: "various-types.plist", sub: .plist))
    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "varioustype.plist", sub: .plist)
  }
}
