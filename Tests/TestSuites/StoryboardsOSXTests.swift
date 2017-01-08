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


class StoryboardsOSXTests: XCTestCase {
  func testOSXEmpty() {
    let parser = StoryboardParser()

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "storyboards-osx-empty.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testOSXMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "storyboards-osx-messages.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testOSXAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "storyboards-osx-anonymous.plist")
    
    XCTDiffContexts(result, expected)
  }

  func testOSXAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    let expected = Fixtures.context(for: "storyboards-osx-all.plist")
    
    XCTDiffContexts(result, expected)
  }
}
