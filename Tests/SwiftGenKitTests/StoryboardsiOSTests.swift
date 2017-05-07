//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import SwiftGenKit

/**
 * Important: In order for the "*.storyboard" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.storyboard" using PBXCp »
 */

class StoryboardsiOSTests: XCTestCase {

  func testEmpty() {
    let parser = StoryboardParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .storyboardsiOS)
  }

  func testMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "messages.plist", sub: .storyboardsiOS)
  }

  func testAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "anonymous.plist", sub: .storyboardsiOS)
  }

  func testAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all.plist", sub: .storyboardsiOS)
  }

  func testAllStoryboardsWithCustomName() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(sceneEnumName: "XCTStoryboardsScene", segueEnumName: "XCTStoryboardsSegue")
    XCTDiffContexts(result, expected: "customname.plist", sub: .storyboardsiOS)
  }
}
