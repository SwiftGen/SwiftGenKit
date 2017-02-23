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
    XCTDiffContexts(result, expected: "empty.plist", sub: .fonts)
  }

  func testDefaults() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory(sub: .fonts))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .fonts)
  }

  func testCustomName() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory(sub: .fonts))

    let result = parser.stencilContext(enumName: "CustomFamily")
    XCTDiffContexts(result, expected: "customname.plist", sub: .fonts)
  }
}
