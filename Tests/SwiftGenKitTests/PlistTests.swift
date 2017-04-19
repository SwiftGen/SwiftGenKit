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
    let expected = [String: Any]()

    XCTDiffContexts(result, expected)
  }
  func testFileWithDefaults() {
    let parser = PlistParser()
    parser.parse(at: Fixtures.path(for: "default.plist", sub: .plist))
    let result = parser.stencilContext()
    let expected = [
      "stringKeys": [
        "UIUserInterfaceStyle",
        "CFBundleShortVersionString",
        "CFBundleExecutable",
        "CFBundleInfoDictionaryVersion",
        "UIMainStoryboardFile",
        "CFBundleDevelopmentRegion",
        "CFBundlePackageType",
        "CFBundleName",
        "CFBundleVersion",
        "CFBundleIdentifier",
      ],
      "boolKeys": [
        "LSRequiresIPhoneOS",
      ],
      "arrayKeys": [
        "UIRequiredDeviceCapabilities",
      ]
    ]
    XCTDiffContexts(result, expected)
  }
  func testFileWithVariousTypeContents() {
    let parser = PlistParser()
    parser.parse(at: Fixtures.path(for: "various-types.plist", sub: .plist))
    let result = parser.stencilContext()
    let expected = [
      "stringKeys": [
        "CFBundleIdentifier",
      ],
      "boolKeys": [
        "LSRequiresIPhoneOS",
      ],
      "dictKeys": [
        "NSAppTransportSecurity",
      ],
      "dateKeys": [
        "SomeDate",
      ],
      "dataKeys": [
        "SomeData",
      ],
      "intKeys": [
        "SomeNumber",
      ],
      "arrayKeys": [
        "ArrayOfManyTypes",
      ],
    ]
    XCTDiffContexts(result, expected)
  }
}
