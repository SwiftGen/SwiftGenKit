//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

extension StoryboardParser {
  public struct SceneElement: Typable {
    let platform: StoryboardParser.Platform
    let tag: String
    let customClass: String?
    let customModule: String?
    var klass: String {
      let defaultClass: String
      switch platform {
      case .iOS:
        defaultClass = "UI\(tag.capitalizedFirstLetter)"
      case .macOS:
        defaultClass = "NS\(tag.capitalizedFirstLetter)"
      }
      return customClass ?? defaultClass
    }
  }
}

extension StoryboardParser.SceneElement: Hashable, Equatable {
  public var hashValue: Int {
    return (platform.hashValue ^ tag.hashValue ^ klass.hashValue)
  }
}

public func == (lhs: StoryboardParser.SceneElement, rhs: StoryboardParser.SceneElement) -> Bool {
  return lhs.platform == rhs.platform &&
    lhs.tag == rhs.tag &&
    lhs.klass == rhs.klass
}

public func == (lhs: StoryboardParser.Scene, rhs: StoryboardParser.Scene) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.storyboardId == rhs.storyboardId &&
    lhs.type == rhs.type &&
    lhs.isInitial == rhs.isInitial &&
    lhs.reuseIdentifiers == rhs.reuseIdentifiers &&
    lhs.segues == rhs.segues
}

extension StoryboardParser.Scene {
  public init(identifier: String,
              storyboardId: String?,
              platform: StoryboardParser.Platform,
              tag: String,
              customClass: String?,
              customModule: String?,
              isInitial: Bool,
              reuseIdentifiers: Set<StoryboardParser.Cell>,
              segues: Set<StoryboardParser.Segue>) {
    self.identifier = identifier
    self.storyboardId = storyboardId ?? ""
    self.type = StoryboardParser.SceneElement(platform: platform,
                                             tag: tag,
                                             customClass: customClass,
                                             customModule: customModule)
    self.isInitial = isInitial
    self.reuseIdentifiers = reuseIdentifiers
    self.segues = segues
  }
}
