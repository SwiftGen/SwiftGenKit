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
    let parser = FontsParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .fonts)
  }

  func testDefaults() {
    let parser = FontsParser()
    parser.parse(path: Fixtures.directory(sub: .fonts))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .fonts)
  }
}
