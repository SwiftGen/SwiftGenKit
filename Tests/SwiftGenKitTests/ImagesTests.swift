//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import SwiftGenKit
import PathKit

/**
 * Important: In order for the "*.xcassets" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.xccassets" using PBXCp »
 */

class ImagesTests: XCTestCase {
  func testEmpty() {
    let parser = AssetsCatalogParser()

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "empty.plist", sub: .images)

    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets", sub: .images))

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "defaults.plist", sub: .images)

    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets", sub: .images))

    let result = parser.stencilContext(enumName: "XCTImages")
    let expected = Fixtures.context(for: "customname.plist", sub: .images)

    XCTDiffContexts(result, expected)
  }
}
