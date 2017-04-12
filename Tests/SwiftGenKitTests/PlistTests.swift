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
    let expected = [
      "plistKeys": []
    ]

    XCTDiffContexts(result, expected)
  }
  func testFileWithDefaults() {
    let parser = PlistParser()
    parser.parse(at: Fixtures.path(for: "default.plist", sub: .plist))
    let result = parser.stencilContext()
    let expected = [
      "plistKeys": [
        "UIUserInterfaceStyle",
        "CFBundleShortVersionString",
        "CFBundleExecutable",
        "CFBundleInfoDictionaryVersion",
        "UIMainStoryboardFile",
        "CFBundleDevelopmentRegion",
        "CFBundlePackageType",
        "LSRequiresIPhoneOS",
        "CFBundleName",
        "CFBundleVersion",
        "CFBundleIdentifier",
        "UIRequiredDeviceCapabilities"
      ]
    ]
    XCTDiffContexts(result, expected)
  }
}
