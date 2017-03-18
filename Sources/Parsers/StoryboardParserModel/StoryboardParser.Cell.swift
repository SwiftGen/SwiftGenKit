//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

extension StoryboardParser {
  public struct CellElement: Typable {
    let platform: StoryboardParser.Platform
    let tag: String
    let customClass: String?
    let customModule: String?
    var klass: String {
      let defaultClass: String
      switch platform {
      case .iOS:
        defaultClass = StoryboardParser.CellType(rawValue: tag) == .tableViewCell ?
          "UITableViewCell" : "UICollectionViewCell"
      case .macOS:
        defaultClass = StoryboardParser.CellType(rawValue: tag) == .tableViewCell ?
          "NSTableViewCell" : "NSCollectionViewCell"
      }
      return customClass ?? defaultClass
    }
  }
}

extension StoryboardParser.CellElement {
  public init(platform: StoryboardParser.Platform,
              cellType: StoryboardParser.CellType,
              customClass: String?,
              customModule: String?) {
    self.platform = platform
    self.tag = cellType.rawValue
    self.customClass = customClass
    self.customModule = customModule
  }
}

extension StoryboardParser.CellElement: Hashable, Equatable {
  public var hashValue: Int {
    return (platform.hashValue ^ tag.hashValue ^ klass.hashValue)
  }
}

public func == (lhs: StoryboardParser.CellElement, rhs: StoryboardParser.CellElement) -> Bool {
  return lhs.platform == rhs.platform &&
    lhs.tag == rhs.tag &&
    lhs.klass == rhs.klass
}

extension StoryboardParser.Cell: Hashable, Equatable {
  public var hashValue: Int {
    return (identifier.hashValue ^ storyboardId.hashValue ^ type.hashValue)
  }
}

public func == (lhs: StoryboardParser.Cell, rhs: StoryboardParser.Cell) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.storyboardId == rhs.storyboardId &&
    lhs.type == rhs.type
}

extension StoryboardParser.Cell {
  public init?(platform: StoryboardParser.Platform,
               cellType: StoryboardParser.CellType,
               attributes attributeDict: [String: String]) {
    guard
      let identifier = attributeDict["id"],
      let reuseIdentifier = attributeDict["reuseIdentifier"]
      else {
        return nil
    }
    self.init(identifier: identifier,
              reuseIdentifier: reuseIdentifier,
              platform: platform,
              customClass: attributeDict["customClass"],
              customModule: attributeDict["customModule"],
              cellType: cellType)
  }
}

extension StoryboardParser.Cell {
  public init(identifier: String,
              reuseIdentifier: String,
              platform: StoryboardParser.Platform,
              customClass: String?,
              customModule: String?,
              cellType: StoryboardParser.CellType) {
    self.identifier = identifier
    self.storyboardId = reuseIdentifier
    self.type = StoryboardParser.CellElement(platform: platform,
                                             cellType: cellType,
                                             customClass: customClass,
                                             customModule: customModule)
  }
}
