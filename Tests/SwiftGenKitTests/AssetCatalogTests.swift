//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import SwiftGenKit
import PathKit

class AssetCatalogTests: XCTestCase {
  func testEmpty() {
    let parser = AssetsCatalogParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .images)
  }

  func testDefaults() throws {
    let parser = AssetsCatalogParser()
    try parser.parse(path: Fixtures.path(for: "Images.xcassets", sub: .images))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .images)
  }
}
