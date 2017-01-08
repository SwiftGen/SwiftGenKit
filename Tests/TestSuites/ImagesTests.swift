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
  static let catalogs: [[String: Any]] = [["name": "Images", "assets": [["items": [["name": "Banana", "value": "Exotic/Banana"], ["name": "Mango", "value": "Exotic/Mango"]], "name": "Exotic"], ["name": "Lemon", "value": "Lemon"], ["items": [["name": "Apricot", "value": "Round/Apricot"], ["name": "Orange", "value": "Round/Orange"], ["items": [["name": "Apple", "value": "Round/Apple"], ["items": [["name": "Cherry", "value": "Round/Double/Cherry"]], "name": "Double"], ["name": "Tomato", "value": "Round/Tomato"]], "name": "Red"]], "name": "Round"]]]]
  static let images = ["Exotic/Banana", "Exotic/Mango", "Lemon", "Round/Apple", "Round/Apricot", "Round/Double/Cherry", "Round/Orange", "Round/Tomato"]

  func testEmpty() {
    let parser = AssetsCatalogParser()

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "Asset",
      "catalogs": [[String: Any]](),
      "images": [String]()
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "Asset",
      "catalogs": ImagesTests.catalogs,
      "images": ImagesTests.images
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testFileWithCustomName() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let result = parser.stencilContext(enumName: "XCTImages")
    let expected: [String: Any] = [
      "enumName": "XCTImages",
      "catalogs": ImagesTests.catalogs,
      "images": ImagesTests.images
    ]
    
    XCTDiffContexts(result, expected)
  }
}
