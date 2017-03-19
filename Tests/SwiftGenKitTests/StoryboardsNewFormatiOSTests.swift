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

class StoryboardsNewFormatiOSTests: XCTestCase {

  func testEmpty() {
    let parser = StoryboardParser()

    let result = parser.stencilContext(newFormat: true)
    let expected = Fixtures.context(for: "empty.plist", sub: .storyboardsNewiOS)

    XCTDiffContexts(result, expected)
  }

  func testMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(newFormat: true)
    let expected = Fixtures.context(for: "messages.plist", sub: .storyboardsNewiOS)

    XCTDiffContexts(result, expected)
  }

  func testAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(newFormat: true)
    let expected = Fixtures.context(for: "anonymous.plist", sub: .storyboardsNewiOS)

    XCTDiffContexts(result, expected)
  }

  func testAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(newFormat: true)
    let expected = Fixtures.context(for: "all.plist", sub: .storyboardsNewiOS)

    XCTDiffContexts(result, expected)
  }

  func testAllStoryboardsWithCustomName() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(sceneEnumName: "XCTStoryboardsScene",
                                       segueEnumName: "XCTStoryboardsSegue", newFormat: true)
    let expected = Fixtures.context(for: "customname.plist", sub: .storyboardsNewiOS)

    XCTDiffContexts(result, expected)
  }

}
