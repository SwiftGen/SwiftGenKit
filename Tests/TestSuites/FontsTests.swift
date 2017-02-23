//
//  FontsTests.swift
//  SwiftGenKit
//
//  Created by Derek Ostrander on 3/8/16.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import XCTest
import SwiftGenKit
import AppKit.NSFont

class FontsTests: XCTestCase {
  func testEmpty() {
    let parser = FontsFileParser()

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "empty.plist", sub: .fonts)

    XCTDiffContexts(result, expected)
  }

  func testDefaults() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory(sub: .fonts))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "defaults.plist", sub: .fonts)

    XCTDiffContexts(result, expected)
  }

  func testCustomName() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory(sub: .fonts))

    let result = parser.stencilContext(enumName: "CustomFamily")
    let expected = Fixtures.context(for: "customname.plist", sub: .fonts)

    XCTDiffContexts(result, expected)
  }
}
